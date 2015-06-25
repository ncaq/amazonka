{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE ViewPatterns               #-}

-- Module      : Network.AWS.Types
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Network.AWS.Types
    (
    -- * Authentication
    -- ** Credentials
      AccessKey     (..)
    , SecretKey     (..)
    , SecurityToken (..)
    -- ** Environment
    , AuthEnv       (..)
    , Auth          (..)
    , withAuth

    -- * Services
    , AWSService    (..)
    , Abbrev
    , Service       (..)

    -- * Retries
    , Retry         (..)

    -- * Errors
    , AWSError       (..)
    , Error         (..)

    -- * Signing
    , AWSSigner     (..)
    , AWSPresigner  (..)
    , Meta
    , Signed        (..)
    , sgMeta
    , sgRequest
    , hmacSHA256

    -- * Requests
    , AWSRequest    (..)
    , Request       (..)
    , rqMethod
    , rqHeaders
    , rqPath
    , rqQuery
    , rqBody

    -- * Responses
    , Response

    -- * Logging
    , LogLevel      (..)
    , Logger

    -- * Regions
    , Endpoint      (..)
    , Region        (..)

    -- * Convenience
    , ClientRequest
    , ClientResponse
    , ResponseBody
    , clientRequest

    , _Coerce
    , _Default
    ) where

import           Control.Applicative
import           Control.Concurrent           (ThreadId)
import           Control.Lens                 hiding (coerce)
import           Control.Monad.Except
import           Control.Monad.Trans.Resource
import qualified Crypto.Hash.SHA256           as SHA256
import qualified Crypto.MAC.HMAC              as HMAC
import           Data.Aeson                   hiding (Error)
import           Data.ByteString.Builder      (Builder)
import           Data.Coerce
import           Data.Conduit
import           Data.Hashable
import           Data.IORef
import           Data.Monoid
import           Data.String
import qualified Data.Text.Encoding           as Text
import           Data.Time
import           GHC.Generics
import           Network.AWS.Data.Body
import           Network.AWS.Data.ByteString
import           Network.AWS.Data.Query
import           Network.AWS.Data.Text
import           Network.AWS.Data.XML
import           Network.HTTP.Client          hiding (Request, Response, Proxy)
import qualified Network.HTTP.Client          as Client
import           Network.HTTP.Types.Header
import           Network.HTTP.Types.Method
import           Network.HTTP.Types.Status    (Status)
import           Text.XML                     (def)
import Network.AWS.Logger
import           Network.AWS.Error

-- | A convenience alias to avoid type ambiguity.
type ClientRequest = Client.Request

-- | A convenience alias encapsulating the common 'Response'.
type ClientResponse = Client.Response ResponseBody

-- | A convenience alias encapsulating the common 'Response' body.
type ResponseBody = ResumableSource (ResourceT IO) ByteString

-- | Construct a 'ClientRequest' using common parameters such as TLS and prevent
-- throwing errors when receiving erroneous status codes in respones.
clientRequest :: ClientRequest
clientRequest = def
    { Client.secure      = True
    , Client.port        = 443
    , Client.checkStatus = \_ _ _ -> Nothing
    }

data Endpoint = Endpoint
    { _endpointHost  :: ByteString
    , _endpointScope :: ByteString
    } deriving (Eq, Show)

-- | Constants and predicates used to create a 'RetryPolicy'.
data Retry = Exponential
    { _retryBase     :: !Double
    , _retryGrowth   :: !Int
    , _retryAttempts :: !Int
    , _retryCheck    :: ServiceError -> Bool
    }

-- | Attributes and functions specific to an AWS service.
data Service v s = Service
    { _svcAbbrev   :: Abbrev
    , _svcPrefix   :: ByteString
    , _svcVersion  :: ByteString
    , _svcEndpoint :: Region -> Endpoint
    , _svcTimeout  :: !Int
    , _svcStatus   :: Status -> Bool
    , _svcError    :: Abbrev -> Status -> [Header] -> LazyByteString -> Error
    , _svcRetry    :: Retry
    }

type Response a = Either Error (Status, Rs a)

-- | An unsigned request.
data Request a = Request
    { _rqMethod  :: !StdMethod
    , _rqPath    :: ByteString
    , _rqQuery   :: QueryString
    , _rqHeaders :: [Header]
    , _rqBody    :: RqBody
    }

instance ToBuilder (Request a) where
    build Request{..} = buildLines
        [ "[Raw Request] {"
        , "  method  = "  <> build _rqMethod
        , "  path    = "  <> build _rqPath
        , "  query   = "  <> build _rqQuery
        , "  headers = "  <> build _rqHeaders
        , "  body    = {"
        , "    hash    = "  <> build (_rqBody ^. bodyHash)
        , "    payload =\n" <> build (_bdyBody _rqBody)
        , "  }"
        , "}"
        ]

rqBody :: Lens' (Request a) RqBody
rqBody = lens _rqBody (\s a -> s { _rqBody = a })

rqHeaders :: Lens' (Request a) [Header]
rqHeaders = lens _rqHeaders (\s a -> s { _rqHeaders = a })

rqMethod :: Lens' (Request a) StdMethod
rqMethod = lens _rqMethod (\s a -> s { _rqMethod = a })

rqPath :: Lens' (Request a) ByteString
rqPath = lens _rqPath (\s a -> s { _rqPath = a })

rqQuery :: Lens' (Request a) QueryString
rqQuery = lens _rqQuery (\s a -> s { _rqQuery = a })

class AWSSigner v where
    signed :: AuthEnv
           -> Region
           -> UTCTime
           -> Service v s
           -> Request a
           -> Signed  v a

class AWSPresigner v where
    presigned :: AuthEnv
              -> Region
              -> UTCTime
              -> Integer
              -> Service v s
              -> Request a
              -> Signed  v a

-- | Signing metadata data specific to a signing algorithm.
--
-- /Note:/ this is used for logging purposes, and is otherwise ignored.
data family Meta v :: *

-- | A signed 'ClientRequest' and associated metadata specific to the signing
-- algorithm that was used.
data Signed v a where
    Signed :: ToBuilder (Meta v)
           => { _sgMeta    :: Meta v
              , _sgRequest :: ClientRequest
              }
           -> Signed v a

sgMeta :: Lens' (Signed v a) (Meta v)
sgMeta f (Signed m rq) = f m <&> \y -> Signed y rq

-- Lens' specifically since 'a' cannot be substituted.
sgRequest :: Lens' (Signed v a) ClientRequest
sgRequest f (Signed m rq) = f rq <&> \y -> Signed m y

class AWSSigner (Sg a) => AWSService a where
    -- | The default signing algorithm for the service.
    type Sg a :: *

    service :: Sv p ~ a => p -> Service (Sg a) a

-- | Specify how a request can be de/serialised.
class AWSService (Sv a) => AWSRequest a where
    -- | The successful, expected response associated with a request.
    type Rs a :: *

    -- | The default sevice configuration for the request.
    type Sv a :: *

    request  :: a -> Request a
    response :: MonadResource m
             => Logger
             -> Service v s
             -> Request a
             -> Either HttpException ClientResponse
             -> m (Response a)

hmacSHA256 :: ByteString -> ByteString -> ByteString
hmacSHA256 = HMAC.hmac SHA256.hash 64

-- | Access key credential.
newtype AccessKey = AccessKey ByteString
    deriving (Eq, Show, IsString, ToText, ToByteString, ToBuilder)

-- | Secret key credential.
newtype SecretKey = SecretKey ByteString
    deriving (Eq, IsString, ToText, ToByteString)

-- | A security token used by STS to temporarily authorise access to
-- an AWS resource.
newtype SecurityToken = SecurityToken ByteString
    deriving (Eq, IsString, ToText, ToByteString)

-- | The authorisation environment.
data AuthEnv = AuthEnv
    { _authAccess :: !AccessKey
    , _authSecret :: !SecretKey
    , _authToken  :: Maybe SecurityToken
    , _authExpiry :: Maybe UTCTime
    }

instance ToBuilder AuthEnv where
    build AuthEnv{..} = buildLines
        [ "[Amazonka Auth] {"
        , "  access key     = ****"
        , "  secret key     = ****"
        , "  security token = " <> build (const "****" <$> _authToken :: Maybe Builder)
        , "  expiry         = " <> build _authExpiry
        , "}"
        ]

instance FromJSON AuthEnv where
    parseJSON = withObject "AuthEnv" $ \o -> AuthEnv
        <$> f AccessKey (o .: "AccessKeyId")
        <*> f SecretKey (o .: "SecretAccessKey")
        <*> fmap (f SecurityToken) (o .:? "Token")
        <*> o .:? "Expiration"
      where
        f g = fmap (g . Text.encodeUtf8)

-- | An authorisation environment containing AWS credentials, and potentially
-- a reference which can be refreshed out-of-band as temporary credentials expire.
data Auth
    = Ref  ThreadId (IORef AuthEnv)
    | Auth AuthEnv

instance ToBuilder Auth where
    build (Ref t _) = "[Amazonka Auth] { <thread:" <> build (show t) <> "> }"
    build (Auth  e) = build e

withAuth :: MonadIO m => Auth -> (AuthEnv -> m a) -> m a
withAuth (Ref _ r) f = liftIO (readIORef r) >>= f
withAuth (Auth  e) f = f e

-- | The sum of available AWS regions.
data Region
    = Ireland         -- ^ Europe / eu-west-1
    | Frankfurt       -- ^ Europe / eu-central-1
    | Tokyo           -- ^ Asia Pacific / ap-northeast-1
    | Singapore       -- ^ Asia Pacific / ap-southeast-1
    | Sydney          -- ^ Asia Pacific / ap-southeast-2
    | Beijing         -- ^ China / cn-north-1
    | NorthVirginia   -- ^ US / us-east-1
    | NorthCalifornia -- ^ US / us-west-1
    | Oregon          -- ^ US / us-west-2
    | GovCloud        -- ^ AWS GovCloud / us-gov-west-1
    | GovCloudFIPS    -- ^ AWS GovCloud (FIPS 140-2) S3 Only / fips-us-gov-west-1
    | SaoPaulo        -- ^ South America / sa-east-1
      deriving (Eq, Ord, Read, Show, Generic)

instance Hashable Region

instance FromText Region where
    parser = takeLowerText >>= \case
        "eu-west-1"          -> pure Ireland
        "eu-central-1"       -> pure Frankfurt
        "ap-northeast-1"     -> pure Tokyo
        "ap-southeast-1"     -> pure Singapore
        "ap-southeast-2"     -> pure Sydney
        "cn-north-1"         -> pure Beijing
        "us-east-1"          -> pure NorthVirginia
        "us-west-2"          -> pure Oregon
        "us-west-1"          -> pure NorthCalifornia
        "us-gov-west-1"      -> pure GovCloud
        "fips-us-gov-west-1" -> pure GovCloudFIPS
        "sa-east-1"          -> pure SaoPaulo
        e                    -> fail $
            "Failure parsing Region from " ++ show e

instance ToText Region where
    toText = \case
        Ireland         -> "eu-west-1"
        Frankfurt       -> "eu-central-1"
        Tokyo           -> "ap-northeast-1"
        Singapore       -> "ap-southeast-1"
        Sydney          -> "ap-southeast-2"
        Beijing         -> "cn-north-1"
        NorthVirginia   -> "us-east-1"
        NorthCalifornia -> "us-west-1"
        Oregon          -> "us-west-2"
        GovCloud        -> "us-gov-west-1"
        GovCloudFIPS    -> "fips-us-gov-west-1"
        SaoPaulo        -> "sa-east-1"

instance ToByteString Region

instance ToBuilder Region where
    build = build . toBS

instance FromXML Region where parseXML = parseXMLText "Region"
instance ToXML   Region where toXML    = toXMLText

_Coerce :: (Coercible a b, Coercible b a) => Iso' a b
_Coerce = iso coerce coerce

-- | Invalid Iso, should be a Prism but exists for ease of composition
-- with the current 'Lens . Iso' chaining to hide internal types from the user.
_Default :: Monoid a => Iso' (Maybe a) a
_Default = iso f Just
  where
    f (Just x) = x
    f Nothing  = mempty
