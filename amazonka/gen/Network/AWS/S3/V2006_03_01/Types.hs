{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.S3.V2006_03_01.Types
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)


module Network.AWS.S3.V2006_03_01.Types where

import Control.Applicative
import Control.Exception      (Exception)
import Data.Default
import Data.Tagged
import Data.Text              (Text)
import Data.Typeable
import GHC.Generics
import Network.AWS.Data
import Network.AWS.Signing.V4
import Network.AWS.Types      hiding (Error)
import Network.HTTP.Client    (HttpException)

-- | Supported version (@2006-03-01@) of the
-- @Amazon Simple Storage Service@ service.
data S3 deriving (Typeable)

instance AWSService S3 where
    type Sg S3 = V4
    data Er S3
        = BucketAlreadyExists
        | NoSuchBucket
        | NoSuchKey
        | NoSuchUpload
        | ObjectAlreadyInActiveTierError
        | ObjectNotInActiveTierError
        | S3Client HttpException
        | S3Serializer String
        | S3Service String

    service = Service
        { _svcEndpoint = Global
        , _svcPrefix   = "s3"
        , _svcVersion  = "2006-03-01"
        , _svcTarget   = Nothing
        }

deriving instance Show     (Er S3)
deriving instance Generic  (Er S3)

instance AWSError (Er S3) where
    awsError = const "S3Error"

instance ServiceError (Er S3) where
    serviceError    = S3Service
    clientError     = S3Client
    serializerError = S3Serializer

instance Exception (Er S3)

xmlOptions :: Tagged a XMLOptions
xmlOptions = Tagged def
    { xmlNamespace = Just "http://s3.amazonaws.com/doc/2006-03-01/"
    }

-- | The versioning state of the bucket.
data BucketVersioningStatus

instance FromText (Switch BucketVersioningStatus) where
    parser = match "Suspended" Disabled
         <|> match "Enabled" Enabled

instance ToText (Switch BucketVersioningStatus) where
    toText Disabled = "Suspended"
    toText Enabled = "Enabled"

instance ToByteString (Switch BucketVersioningStatus) where
    toBS Disabled = "Suspended"
    toBS Enabled = "Enabled"

instance FromXML (Switch BucketVersioningStatus) where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "BucketVersioningStatus"

instance ToXML (Switch BucketVersioningStatus) where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "BucketVersioningStatus"

-- | If 'Enabled', the rule is currently being applied. If 'Disabled', the rule
-- is not currently being applied.
data ExpirationStatus

instance FromText (Switch ExpirationStatus) where
    parser = match "Disabled" Disabled
         <|> match "Enabled" Enabled

instance ToText (Switch ExpirationStatus) where
    toText Disabled = "Disabled"
    toText Enabled = "Enabled"

instance ToByteString (Switch ExpirationStatus) where
    toBS Disabled = "Disabled"
    toBS Enabled = "Enabled"

instance FromXML (Switch ExpirationStatus) where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ExpirationStatus"

instance ToXML (Switch ExpirationStatus) where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ExpirationStatus"

-- | Specifies whether MFA delete is enabled in the bucket versioning
-- configuration. This element is only returned if the bucket has been
-- configured with MFA delete. If the bucket has never been so configured,
-- this element is not returned.
data MFADelete

instance FromText (Switch MFADelete) where
    parser = match "Disabled" Disabled
         <|> match "Enabled" Enabled

instance ToText (Switch MFADelete) where
    toText Disabled = "Disabled"
    toText Enabled = "Enabled"

instance ToByteString (Switch MFADelete) where
    toBS Disabled = "Disabled"
    toBS Enabled = "Enabled"

instance FromXML (Switch MFADelete) where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "MfaDelete"

instance ToXML (Switch MFADelete) where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "MfaDelete"

-- | Specifies whether MFA delete is enabled in the bucket versioning
-- configuration. This element is only returned if the bucket has been
-- configured with MFA delete. If the bucket has never been so configured,
-- this element is not returned.
data MFADeleteStatus

instance FromText (Switch MFADeleteStatus) where
    parser = match "Disabled" Disabled
         <|> match "Enabled" Enabled

instance ToText (Switch MFADeleteStatus) where
    toText Disabled = "Disabled"
    toText Enabled = "Enabled"

instance ToByteString (Switch MFADeleteStatus) where
    toBS Disabled = "Disabled"
    toBS Enabled = "Enabled"

instance FromXML (Switch MFADeleteStatus) where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "MfaDelete"

instance ToXML (Switch MFADeleteStatus) where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "MfaDelete"

-- | The canned ACL to apply to the bucket.
data BucketCannedACL
    = BucketCannedACLAuthenticatedRead -- ^ authenticated-read
    | BucketCannedACLPrivate -- ^ private
    | BucketCannedACLPublicRead -- ^ public-read
    | BucketCannedACLPublicReadWrite -- ^ public-read-write
      deriving (Eq, Show, Generic)

instance FromText BucketCannedACL where
    parser = match "authenticated-read" BucketCannedACLAuthenticatedRead
         <|> match "private" BucketCannedACLPrivate
         <|> match "public-read" BucketCannedACLPublicRead
         <|> match "public-read-write" BucketCannedACLPublicReadWrite

instance ToText BucketCannedACL where
    toText BucketCannedACLAuthenticatedRead = "authenticated-read"
    toText BucketCannedACLPrivate = "private"
    toText BucketCannedACLPublicRead = "public-read"
    toText BucketCannedACLPublicReadWrite = "public-read-write"

instance ToByteString BucketCannedACL where
    toBS BucketCannedACLAuthenticatedRead = "authenticated-read"
    toBS BucketCannedACLPrivate = "private"
    toBS BucketCannedACLPublicRead = "public-read"
    toBS BucketCannedACLPublicReadWrite = "public-read-write"

instance FromXML BucketCannedACL where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "BucketCannedACL"

instance ToXML BucketCannedACL where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "BucketCannedACL"

-- | Specifies the region where the bucket will be created.
newtype BucketLocationConstraint = BucketLocationConstraint Region
    deriving (Eq, Show, Generic)

instance FromText BucketLocationConstraint where
    parser = BucketLocationConstraint <$> parser

instance ToText BucketLocationConstraint where
    toText (BucketLocationConstraint r) = toText r

instance ToByteString BucketLocationConstraint where
    toBS (BucketLocationConstraint r) = toBS r

instance FromXML BucketLocationConstraint where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "BucketLocationConstraint"
    fromXML        = const fromNodeContent

instance ToXML BucketLocationConstraint where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "BucketLocationConstraint"
    toXML o      = toXML (retag o) . toText

-- | Logging permissions assigned to the Grantee for the bucket.
data BucketLogsPermission
    = BucketLogsPermissionFullControl -- ^ FULL_CONTROL
    | BucketLogsPermissionRead -- ^ READ
    | BucketLogsPermissionWrite -- ^ WRITE
      deriving (Eq, Show, Generic)

instance FromText BucketLogsPermission where
    parser = match "FULL_CONTROL" BucketLogsPermissionFullControl
         <|> match "READ" BucketLogsPermissionRead
         <|> match "WRITE" BucketLogsPermissionWrite

instance ToText BucketLogsPermission where
    toText BucketLogsPermissionFullControl = "FULL_CONTROL"
    toText BucketLogsPermissionRead = "READ"
    toText BucketLogsPermissionWrite = "WRITE"

instance ToByteString BucketLogsPermission where
    toBS BucketLogsPermissionFullControl = "FULL_CONTROL"
    toBS BucketLogsPermissionRead = "READ"
    toBS BucketLogsPermissionWrite = "WRITE"

instance FromXML BucketLogsPermission where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "BucketLogsPermission"

instance ToXML BucketLogsPermission where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "BucketLogsPermission"

-- | Requests Amazon S3 to encode the object keys in the response and specifies
-- the encoding method to use. An object key may contain any Unicode
-- character; however, XML 1.0 parser cannot parse some characters, such as
-- characters with an ASCII value from 0 to 10. For characters that are not
-- supported in XML 1.0, you can add this parameter to request that Amazon S3
-- encode the keys in the response.
data EncodingType
    = EncodingTypeUrl -- ^ url
      deriving (Eq, Show, Generic)

instance FromText EncodingType where
    parser = match "url" EncodingTypeUrl

instance ToText EncodingType where
    toText EncodingTypeUrl = "url"

instance ToByteString EncodingType where
    toBS EncodingTypeUrl = "url"

instance FromXML EncodingType where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "EncodingType"

instance ToXML EncodingType where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "EncodingType"

-- | Bucket event for which to send notifications.
data Event
    = EventS3ReducedRedundancyLostObject -- ^ s3:ReducedRedundancyLostObject
      deriving (Eq, Show, Generic)

instance FromText Event where
    parser = match "s3:ReducedRedundancyLostObject" EventS3ReducedRedundancyLostObject

instance ToText Event where
    toText EventS3ReducedRedundancyLostObject = "s3:ReducedRedundancyLostObject"

instance ToByteString Event where
    toBS EventS3ReducedRedundancyLostObject = "s3:ReducedRedundancyLostObject"

instance FromXML Event where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Event"

instance ToXML Event where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Event"

-- | Specifies whether the metadata is copied from the source object or replaced
-- with metadata provided in the request.
data MetadataDirective
    = MetadataDirectiveCopy -- ^ COPY
    | MetadataDirectiveReplace -- ^ REPLACE
      deriving (Eq, Show, Generic)

instance FromText MetadataDirective where
    parser = match "COPY" MetadataDirectiveCopy
         <|> match "REPLACE" MetadataDirectiveReplace

instance ToText MetadataDirective where
    toText MetadataDirectiveCopy = "COPY"
    toText MetadataDirectiveReplace = "REPLACE"

instance ToByteString MetadataDirective where
    toBS MetadataDirectiveCopy = "COPY"
    toBS MetadataDirectiveReplace = "REPLACE"

instance FromXML MetadataDirective where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "MetadataDirective"

instance ToXML MetadataDirective where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "MetadataDirective"

-- | The canned ACL to apply to the object.
data ObjectCannedACL
    = ObjectCannedACLAuthenticatedRead -- ^ authenticated-read
    | ObjectCannedACLBucketOwnerFullControl -- ^ bucket-owner-full-control
    | ObjectCannedACLBucketOwnerRead -- ^ bucket-owner-read
    | ObjectCannedACLPrivate -- ^ private
    | ObjectCannedACLPublicRead -- ^ public-read
    | ObjectCannedACLPublicReadWrite -- ^ public-read-write
      deriving (Eq, Show, Generic)

instance FromText ObjectCannedACL where
    parser = match "authenticated-read" ObjectCannedACLAuthenticatedRead
         <|> match "bucket-owner-full-control" ObjectCannedACLBucketOwnerFullControl
         <|> match "bucket-owner-read" ObjectCannedACLBucketOwnerRead
         <|> match "private" ObjectCannedACLPrivate
         <|> match "public-read" ObjectCannedACLPublicRead
         <|> match "public-read-write" ObjectCannedACLPublicReadWrite

instance ToText ObjectCannedACL where
    toText ObjectCannedACLAuthenticatedRead = "authenticated-read"
    toText ObjectCannedACLBucketOwnerFullControl = "bucket-owner-full-control"
    toText ObjectCannedACLBucketOwnerRead = "bucket-owner-read"
    toText ObjectCannedACLPrivate = "private"
    toText ObjectCannedACLPublicRead = "public-read"
    toText ObjectCannedACLPublicReadWrite = "public-read-write"

instance ToByteString ObjectCannedACL where
    toBS ObjectCannedACLAuthenticatedRead = "authenticated-read"
    toBS ObjectCannedACLBucketOwnerFullControl = "bucket-owner-full-control"
    toBS ObjectCannedACLBucketOwnerRead = "bucket-owner-read"
    toBS ObjectCannedACLPrivate = "private"
    toBS ObjectCannedACLPublicRead = "public-read"
    toBS ObjectCannedACLPublicReadWrite = "public-read-write"

instance FromXML ObjectCannedACL where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ObjectCannedACL"

instance ToXML ObjectCannedACL where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ObjectCannedACL"

-- | The class of storage used to store the object.
data ObjectStorageClass
    = ObjectStorageClassGlacier -- ^ GLACIER
    | ObjectStorageClassReducedRedundancy -- ^ REDUCED_REDUNDANCY
    | ObjectStorageClassStandard -- ^ STANDARD
      deriving (Eq, Show, Generic)

instance FromText ObjectStorageClass where
    parser = match "GLACIER" ObjectStorageClassGlacier
         <|> match "REDUCED_REDUNDANCY" ObjectStorageClassReducedRedundancy
         <|> match "STANDARD" ObjectStorageClassStandard

instance ToText ObjectStorageClass where
    toText ObjectStorageClassGlacier = "GLACIER"
    toText ObjectStorageClassReducedRedundancy = "REDUCED_REDUNDANCY"
    toText ObjectStorageClassStandard = "STANDARD"

instance ToByteString ObjectStorageClass where
    toBS ObjectStorageClassGlacier = "GLACIER"
    toBS ObjectStorageClassReducedRedundancy = "REDUCED_REDUNDANCY"
    toBS ObjectStorageClassStandard = "STANDARD"

instance FromXML ObjectStorageClass where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ObjectStorageClass"

instance ToXML ObjectStorageClass where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ObjectStorageClass"

-- | The class of storage used to store the object.
data ObjectVersionStorageClass
    = ObjectVersionStorageClassStandard -- ^ STANDARD
      deriving (Eq, Show, Generic)

instance FromText ObjectVersionStorageClass where
    parser = match "STANDARD" ObjectVersionStorageClassStandard

instance ToText ObjectVersionStorageClass where
    toText ObjectVersionStorageClassStandard = "STANDARD"

instance ToByteString ObjectVersionStorageClass where
    toBS ObjectVersionStorageClassStandard = "STANDARD"

instance FromXML ObjectVersionStorageClass where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ObjectVersionStorageClass"

instance ToXML ObjectVersionStorageClass where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ObjectVersionStorageClass"

-- | Specifies who pays for the download and request fees.
data Payer
    = PayerBucketOwner -- ^ BucketOwner
    | PayerRequester -- ^ Requester
      deriving (Eq, Show, Generic)

instance FromText Payer where
    parser = match "BucketOwner" PayerBucketOwner
         <|> match "Requester" PayerRequester

instance ToText Payer where
    toText PayerBucketOwner = "BucketOwner"
    toText PayerRequester = "Requester"

instance ToByteString Payer where
    toBS PayerBucketOwner = "BucketOwner"
    toBS PayerRequester = "Requester"

instance FromXML Payer where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Payer"

instance ToXML Payer where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Payer"

-- | Specifies the permission given to the grantee.
data Permission
    = PermissionFullControl -- ^ FULL_CONTROL
    | PermissionRead -- ^ READ
    | PermissionReadAcp -- ^ READ_ACP
    | PermissionWrite -- ^ WRITE
    | PermissionWriteAcp -- ^ WRITE_ACP
      deriving (Eq, Show, Generic)

instance FromText Permission where
    parser = match "FULL_CONTROL" PermissionFullControl
         <|> match "READ" PermissionRead
         <|> match "READ_ACP" PermissionReadAcp
         <|> match "WRITE" PermissionWrite
         <|> match "WRITE_ACP" PermissionWriteAcp

instance ToText Permission where
    toText PermissionFullControl = "FULL_CONTROL"
    toText PermissionRead = "READ"
    toText PermissionReadAcp = "READ_ACP"
    toText PermissionWrite = "WRITE"
    toText PermissionWriteAcp = "WRITE_ACP"

instance ToByteString Permission where
    toBS PermissionFullControl = "FULL_CONTROL"
    toBS PermissionRead = "READ"
    toBS PermissionReadAcp = "READ_ACP"
    toBS PermissionWrite = "WRITE"
    toBS PermissionWriteAcp = "WRITE_ACP"

instance FromXML Permission where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Permission"

instance ToXML Permission where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Permission"

-- | Protocol to use (http, https) when redirecting requests. The default is the
-- protocol that is used in the original request.
data Protocol
    = ProtocolHttp -- ^ http
    | ProtocolHttps -- ^ https
      deriving (Eq, Show, Generic)

instance FromText Protocol where
    parser = match "http" ProtocolHttp
         <|> match "https" ProtocolHttps

instance ToText Protocol where
    toText ProtocolHttp = "http"
    toText ProtocolHttps = "https"

instance ToByteString Protocol where
    toBS ProtocolHttp = "http"
    toBS ProtocolHttps = "https"

instance FromXML Protocol where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Protocol"

instance ToXML Protocol where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Protocol"

-- | The Server-side encryption algorithm used when storing this object in S3.
data ServerSideEncryption
    = ServerSideEncryptionAES256 -- ^ AES256
      deriving (Eq, Show, Generic)

instance FromText ServerSideEncryption where
    parser = match "AES256" ServerSideEncryptionAES256

instance ToText ServerSideEncryption where
    toText ServerSideEncryptionAES256 = "AES256"

instance ToByteString ServerSideEncryption where
    toBS ServerSideEncryptionAES256 = "AES256"

instance FromXML ServerSideEncryption where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ServerSideEncryption"

instance ToXML ServerSideEncryption where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ServerSideEncryption"

-- | The type of storage to use for the object. Defaults to 'STANDARD'.
data StorageClass
    = StorageClassReducedRedundancy -- ^ REDUCED_REDUNDANCY
    | StorageClassStandard -- ^ STANDARD
      deriving (Eq, Show, Generic)

instance FromText StorageClass where
    parser = match "REDUCED_REDUNDANCY" StorageClassReducedRedundancy
         <|> match "STANDARD" StorageClassStandard

instance ToText StorageClass where
    toText StorageClassReducedRedundancy = "REDUCED_REDUNDANCY"
    toText StorageClassStandard = "STANDARD"

instance ToByteString StorageClass where
    toBS StorageClassReducedRedundancy = "REDUCED_REDUNDANCY"
    toBS StorageClassStandard = "STANDARD"

instance FromXML StorageClass where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "StorageClass"

instance ToXML StorageClass where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "StorageClass"

-- | The class of storage used to store the object.
data TransitionStorageClass
    = TransitionStorageClassGlacier -- ^ GLACIER
      deriving (Eq, Show, Generic)

instance FromText TransitionStorageClass where
    parser = match "GLACIER" TransitionStorageClassGlacier

instance ToText TransitionStorageClass where
    toText TransitionStorageClassGlacier = "GLACIER"

instance ToByteString TransitionStorageClass where
    toBS TransitionStorageClassGlacier = "GLACIER"

instance FromXML TransitionStorageClass where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "TransitionStorageClass"

instance ToXML TransitionStorageClass where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "TransitionStorageClass"

-- | Type of grantee.
data Type
    = TypeAmazonCustomerByEmail -- ^ AmazonCustomerByEmail
    | TypeCanonicalUser -- ^ CanonicalUser
    | TypeGroup -- ^ Group
      deriving (Eq, Show, Generic)

instance FromText Type where
    parser = match "AmazonCustomerByEmail" TypeAmazonCustomerByEmail
         <|> match "CanonicalUser" TypeCanonicalUser
         <|> match "Group" TypeGroup

instance ToText Type where
    toText TypeAmazonCustomerByEmail = "AmazonCustomerByEmail"
    toText TypeCanonicalUser = "CanonicalUser"
    toText TypeGroup = "Group"

instance ToByteString Type where
    toBS TypeAmazonCustomerByEmail = "AmazonCustomerByEmail"
    toBS TypeCanonicalUser = "CanonicalUser"
    toBS TypeGroup = "Group"

instance FromXML Type where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "xsi:type"

instance ToXML Type where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "xsi:type"

newtype BucketLoggingStatus = BucketLoggingStatus
    { _blsLoggingEnabled :: LoggingEnabled
    } deriving (Generic)

instance FromXML BucketLoggingStatus where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "BucketLoggingStatus"

instance ToXML BucketLoggingStatus where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "BucketLoggingStatus"

newtype CORSConfiguration = CORSConfiguration
    { _corscCORSRules :: [CORSRule]
    } deriving (Generic)

instance FromXML CORSConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CORSConfiguration"

instance ToXML CORSConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CORSConfiguration"

newtype CommonPrefix = CommonPrefix
    { _cpPrefix :: Text
    } deriving (Generic)

instance FromXML CommonPrefix where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CommonPrefix"

instance ToXML CommonPrefix where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CommonPrefix"

newtype CompletedMultipartUpload = CompletedMultipartUpload
    { _cmuParts :: [CompletedPart]
    } deriving (Generic)

instance FromXML CompletedMultipartUpload where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CompleteMultipartUpload"

instance ToXML CompletedMultipartUpload where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CompleteMultipartUpload"

newtype CreateBucketConfiguration = CreateBucketConfiguration
    { _cbcLocationConstraint :: BucketLocationConstraint
      -- ^ Specifies the region where the bucket will be created.
    } deriving (Generic)

instance FromXML CreateBucketConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CreateBucketConfiguration"

instance ToXML CreateBucketConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CreateBucketConfiguration"

newtype ErrorDocument = ErrorDocument
    { _edKey :: ObjectKey
      -- ^ The object key name to use when a 4XX class error occurs.
    } deriving (Generic)

instance FromXML ErrorDocument where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ErrorDocument"

instance ToXML ErrorDocument where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ErrorDocument"

newtype IndexDocument = IndexDocument
    { _idSuffix :: Text
      -- ^ A suffix that is appended to a request that is for a directory on
      -- the website endpoint (e.g. if the suffix is index.html and you
      -- make a request to samplebucket/images/ the data that is returned
      -- will be for the object with the key name images/index.html) The
      -- suffix must not be empty and must not include a slash character.
    } deriving (Generic)

instance FromXML IndexDocument where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "IndexDocument"

instance ToXML IndexDocument where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "IndexDocument"

newtype LifecycleConfiguration = LifecycleConfiguration
    { _lcRules :: [Rule]
    } deriving (Generic)

instance FromXML LifecycleConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "LifecycleConfiguration"

instance ToXML LifecycleConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "LifecycleConfiguration"

-- | Specifies when noncurrent object versions expire. Upon expiration, Amazon
-- S3 permanently deletes the noncurrent object versions. You set this
-- lifecycle configuration action on a bucket that has versioning enabled (or
-- suspended) to request that Amazon S3 delete noncurrent object versions at a
-- specific period in the object's lifetime.
newtype NoncurrentVersionExpiration = NoncurrentVersionExpiration
    { _nveNoncurrentDays :: Integer
      -- ^ Specifies the number of days an object is noncurrent before
      -- Amazon S3 can perform the associated action. For information
      -- about the noncurrent days calculations, see How Amazon S3
      -- Calculates When an Object Became Noncurrent in the Amazon Simple
      -- Storage Service Developer Guide.
    } deriving (Generic)

instance FromXML NoncurrentVersionExpiration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "NoncurrentVersionExpiration"

instance ToXML NoncurrentVersionExpiration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "NoncurrentVersionExpiration"

newtype NotificationConfiguration = NotificationConfiguration
    { _ncTopicConfiguration :: TopicConfiguration
    } deriving (Generic)

instance FromXML NotificationConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "NotificationConfiguration"

instance ToXML NotificationConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "NotificationConfiguration"

newtype RequestPaymentConfiguration = RequestPaymentConfiguration
    { _rpcPayer :: Payer
      -- ^ Specifies who pays for the download and request fees.
    } deriving (Generic)

instance FromXML RequestPaymentConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "RequestPaymentConfiguration"

instance ToXML RequestPaymentConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "RequestPaymentConfiguration"

newtype RestoreRequest = RestoreRequest
    { _rrDays :: Integer
      -- ^ Lifetime of the active copy in days.
    } deriving (Generic)

instance FromXML RestoreRequest where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "RestoreRequest"

instance ToXML RestoreRequest where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "RestoreRequest"

newtype Tagging = Tagging
    { _tTagSet :: [Tag]
    } deriving (Generic)

instance FromXML Tagging where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Tagging"

instance ToXML Tagging where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Tagging"

data AccessControlPolicy = AccessControlPolicy
    { _acpGrants :: [Grant]
      -- ^ A list of grants.
    , _acpOwner :: Owner
    } deriving (Generic)

instance FromXML AccessControlPolicy where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "AccessControlPolicy"

instance ToXML AccessControlPolicy where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "AccessControlPolicy"

data Bucket = Bucket
    { _bName :: BucketName
      -- ^ The name of the bucket.
    , _bCreationDate :: RFC822
      -- ^ Date the bucket was created.
    } deriving (Generic)

instance FromXML Bucket where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Bucket"

instance ToXML Bucket where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Bucket"

data CORSRule = CORSRule
    { _corsrAllowedMethods :: [Text]
      -- ^ Identifies HTTP methods that the domain/origin specified in the
      -- rule is allowed to execute.
    , _corsrMaxAgeSeconds :: Integer
      -- ^ The time in seconds that your browser is to cache the preflight
      -- response for the specified resource.
    , _corsrAllowedHeaders :: [Text]
      -- ^ Specifies which headers are allowed in a pre-flight OPTIONS
      -- request.
    , _corsrAllowedOrigins :: [Text]
      -- ^ One or more origins you want customers to be able to access the
      -- bucket from.
    , _corsrExposeHeaders :: [Text]
      -- ^ One or more headers in the response that you want customers to be
      -- able to access from their applications (for example, from a
      -- JavaScript XMLHttpRequest object).
    } deriving (Generic)

instance FromXML CORSRule where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CORSRule"

instance ToXML CORSRule where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CORSRule"

data CompletedPart = CompletedPart
    { _cpETag :: ETag
      -- ^ Entity tag returned when the part was uploaded.
    , _cpPartNumber :: Integer
      -- ^ Part number that identifies the part.
    } deriving (Generic)

instance FromXML CompletedPart where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CompletedPart"

instance ToXML CompletedPart where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CompletedPart"

-- | A container for describing a condition that must be met for the specified
-- redirect to apply. For example, 1. If request is for pages in the /docs
-- folder, redirect to the /documents folder. 2. If request results in HTTP
-- error 4xx, redirect request to another host where you might process the
-- error.
data Condition = Condition
    { _cKeyPrefixEquals :: Text
      -- ^ The object key name prefix when the redirect is applied. For
      -- example, to redirect requests for ExamplePage.html, the key
      -- prefix will be ExamplePage.html. To redirect request for all
      -- pages with the prefix docs/, the key prefix will be /docs, which
      -- identifies all objects in the docs/ folder. Required when the
      -- parent element Condition is specified and sibling
      -- HttpErrorCodeReturnedEquals is not specified. If both conditions
      -- are specified, both must be true for the redirect to be applied.
    , _cHttpErrorCodeReturnedEquals :: Text
      -- ^ The HTTP error code when the redirect is applied. In the event of
      -- an error, if the error code equals this value, then the specified
      -- redirect is applied. Required when parent element Condition is
      -- specified and sibling KeyPrefixEquals is not specified. If both
      -- are specified, then both must be true for the redirect to be
      -- applied.
    } deriving (Generic)

instance FromXML Condition where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Condition"

instance ToXML Condition where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Condition"

data CopyObjectResult = CopyObjectResult
    { _corETag :: ETag
    , _corLastModified :: RFC822
    } deriving (Generic)

instance FromXML CopyObjectResult where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CopyObjectResult"

instance ToXML CopyObjectResult where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CopyObjectResult"

data CopyPartResult = CopyPartResult
    { _cprETag :: ETag
      -- ^ Entity tag of the object.
    , _cprLastModified :: RFC822
      -- ^ Date and time at which the object was uploaded.
    } deriving (Generic)

instance FromXML CopyPartResult where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "CopyPartResult"

instance ToXML CopyPartResult where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "CopyPartResult"

data Delete = Delete
    { _dQuiet :: Bool
      -- ^ Element to enable quiet mode for the request. When you add this
      -- element, you must set its value to true.
    , _dObjects :: [ObjectIdentifier]
    } deriving (Generic)

instance FromXML Delete where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Delete"

instance ToXML Delete where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Delete"

data DeleteMarkerEntry = DeleteMarkerEntry
    { _dmeVersionId :: ObjectVersionId
      -- ^ Version ID of an object.
    , _dmeIsLatest :: Bool
      -- ^ Specifies whether the object is (true) or is not (false) the
      -- latest version of an object.
    , _dmeOwner :: Owner
    , _dmeKey :: ObjectKey
      -- ^ The object key.
    , _dmeLastModified :: RFC822
      -- ^ Date and time the object was last modified.
    } deriving (Generic)

instance FromXML DeleteMarkerEntry where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "DeleteMarkerEntry"

instance ToXML DeleteMarkerEntry where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "DeleteMarkerEntry"

data DeletedObject = DeletedObject
    { _doVersionId :: ObjectVersionId
    , _doDeleteMarker :: Bool
    , _doDeleteMarkerVersionId :: Text
    , _doKey :: ObjectKey
    } deriving (Generic)

instance FromXML DeletedObject where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "DeletedObject"

instance ToXML DeletedObject where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "DeletedObject"

data Error = Error
    { _eVersionId :: ObjectVersionId
    , _eKey :: ObjectKey
    , _eCode :: Text
    , _eMessage :: Text
    } deriving (Generic)

instance FromXML Error where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Error"

instance ToXML Error where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Error"

data Grant = Grant
    { _gPermission :: Permission
      -- ^ Specifies the permission given to the grantee.
    , _gGrantee :: Grantee
    } deriving (Generic)

instance FromXML Grant where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Grant"

instance ToXML Grant where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Grant"

data Grantee = Grantee
    { _gURI :: Text
      -- ^ URI of the grantee group.
    , _gEmailAddress :: Text
      -- ^ Email address of the grantee.
    , _gDisplayName :: Text
      -- ^ Screen name of the grantee.
    , _gID :: Text
      -- ^ The canonical user ID of the grantee.
    , _gType :: Type
      -- ^ Type of grantee.
    } deriving (Generic)

instance FromXML Grantee where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Grantee"

instance ToXML Grantee where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Grantee"

-- | Identifies who initiated the multipart upload.
data Initiator = Initiator
    { _iDisplayName :: Text
      -- ^ Name of the Principal.
    , _iID :: Text
      -- ^ If the principal is an AWS account, it provides the Canonical
      -- User ID. If the principal is an IAM User, it provides a user ARN
      -- value.
    } deriving (Generic)

instance FromXML Initiator where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Initiator"

instance ToXML Initiator where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Initiator"

data LifecycleExpiration = LifecycleExpiration
    { _leDays :: Integer
      -- ^ Indicates the lifetime, in days, of the objects that are subject
      -- to the rule. The value must be a non-zero positive integer.
    , _leDate :: RFC822
      -- ^ Indicates at what date the object is to be moved or deleted.
      -- Should be in GMT ISO 8601 Format.
    } deriving (Generic)

instance FromXML LifecycleExpiration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "LifecycleExpiration"

instance ToXML LifecycleExpiration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "LifecycleExpiration"

data LoggingEnabled = LoggingEnabled
    { _leTargetBucket :: Text
      -- ^ Specifies the bucket where you want Amazon S3 to store server
      -- access logs. You can have your logs delivered to any bucket that
      -- you own, including the same bucket that is being logged. You can
      -- also configure multiple buckets to deliver their logs to the same
      -- target bucket. In this case you should choose a different
      -- TargetPrefix for each source bucket so that the delivered log
      -- files can be distinguished by key.
    , _leTargetGrants :: [TargetGrant]
    , _leTargetPrefix :: Text
      -- ^ This element lets you specify a prefix for the keys that the log
      -- files will be stored under.
    } deriving (Generic)

instance FromXML LoggingEnabled where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "LoggingEnabled"

instance ToXML LoggingEnabled where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "LoggingEnabled"

data MultipartUpload = MultipartUpload
    { _muInitiated :: RFC822
      -- ^ Date and time at which the multipart upload was initiated.
    , _muInitiator :: Initiator
      -- ^ Identifies who initiated the multipart upload.
    , _muOwner :: Owner
    , _muKey :: ObjectKey
      -- ^ Key of the object for which the multipart upload was initiated.
    , _muStorageClass :: StorageClass
      -- ^ The class of storage used to store the object.
    , _muUploadId :: Text
      -- ^ Upload ID that identifies the multipart upload.
    } deriving (Generic)

instance FromXML MultipartUpload where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "MultipartUpload"

instance ToXML MultipartUpload where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "MultipartUpload"

-- | Container for the transition rule that describes when noncurrent objects
-- transition to the GLACIER storage class. If your bucket is
-- versioning-enabled (or versioning is suspended), you can set this action to
-- request that Amazon S3 transition noncurrent object versions to the GLACIER
-- storage class at a specific period in the object's lifetime.
data NoncurrentVersionTransition = NoncurrentVersionTransition
    { _nvtStorageClass :: TransitionStorageClass
      -- ^ The class of storage used to store the object.
    , _nvtNoncurrentDays :: Integer
      -- ^ Specifies the number of days an object is noncurrent before
      -- Amazon S3 can perform the associated action. For information
      -- about the noncurrent days calculations, see How Amazon S3
      -- Calculates When an Object Became Noncurrent in the Amazon Simple
      -- Storage Service Developer Guide.
    } deriving (Generic)

instance FromXML NoncurrentVersionTransition where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "NoncurrentVersionTransition"

instance ToXML NoncurrentVersionTransition where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "NoncurrentVersionTransition"

data Object = Object
    { _oETag :: ETag
    , _oSize :: Integer
    , _oOwner :: Owner
    , _oKey :: ObjectKey
    , _oStorageClass :: ObjectStorageClass
      -- ^ The class of storage used to store the object.
    , _oLastModified :: RFC822
    } deriving (Generic)

instance FromXML Object where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Object"

instance ToXML Object where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Object"

data ObjectIdentifier = ObjectIdentifier
    { _oiVersionId :: ObjectVersionId
      -- ^ VersionId for the specific version of the object to delete.
    , _oiKey :: ObjectKey
      -- ^ Key name of the object to delete.
    } deriving (Generic)

instance FromXML ObjectIdentifier where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ObjectIdentifier"

instance ToXML ObjectIdentifier where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ObjectIdentifier"

data ObjectVersion = ObjectVersion
    { _ovETag :: ETag
    , _ovVersionId :: ObjectVersionId
      -- ^ Version ID of an object.
    , _ovSize :: Integer
      -- ^ Size in bytes of the object.
    , _ovIsLatest :: Bool
      -- ^ Specifies whether the object is (true) or is not (false) the
      -- latest version of an object.
    , _ovOwner :: Owner
    , _ovKey :: ObjectKey
      -- ^ The object key.
    , _ovStorageClass :: ObjectVersionStorageClass
      -- ^ The class of storage used to store the object.
    , _ovLastModified :: RFC822
      -- ^ Date and time the object was last modified.
    } deriving (Generic)

instance FromXML ObjectVersion where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "ObjectVersion"

instance ToXML ObjectVersion where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "ObjectVersion"

data Owner = Owner
    { _oDisplayName :: Text
    , _oID :: Text
    } deriving (Generic)

instance FromXML Owner where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Owner"

instance ToXML Owner where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Owner"

data Part = Part
    { _pETag :: ETag
      -- ^ Entity tag returned when the part was uploaded.
    , _pSize :: Integer
      -- ^ Size of the uploaded part data.
    , _pPartNumber :: Integer
      -- ^ Part number identifying the part.
    , _pLastModified :: RFC822
      -- ^ Date and time at which the part was uploaded.
    } deriving (Generic)

instance FromXML Part where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Part"

instance ToXML Part where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Part"

-- | Container for redirect information. You can redirect requests to another
-- host, to another page, or with another protocol. In the event of an error,
-- you can can specify a different error code to return.
data Redirect = Redirect
    { _rHostName :: Text
      -- ^ The host name to use in the redirect request.
    , _rProtocol :: Protocol
      -- ^ Protocol to use (http, https) when redirecting requests. The
      -- default is the protocol that is used in the original request.
    , _rHttpRedirectCode :: Text
      -- ^ The HTTP redirect code to use on the response. Not required if
      -- one of the siblings is present.
    , _rReplaceKeyWith :: Text
      -- ^ The specific object key to use in the redirect request. For
      -- example, redirect request to error.html. Not required if one of
      -- the sibling is present. Can be present only if
      -- ReplaceKeyPrefixWith is not provided.
    , _rReplaceKeyPrefixWith :: Text
      -- ^ The object key prefix to use in the redirect request. For
      -- example, to redirect requests for all pages with prefix docs/
      -- (objects in the docs/ folder) to documents/, you can set a
      -- condition block with KeyPrefixEquals set to docs/ and in the
      -- Redirect set ReplaceKeyPrefixWith to /documents. Not required if
      -- one of the siblings is present. Can be present only if
      -- ReplaceKeyWith is not provided.
    } deriving (Generic)

instance FromXML Redirect where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Redirect"

instance ToXML Redirect where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Redirect"

data RedirectAllRequestsTo = RedirectAllRequestsTo
    { _rartHostName :: Text
      -- ^ Name of the host where requests will be redirected.
    , _rartProtocol :: Protocol
      -- ^ Protocol to use (http, https) when redirecting requests. The
      -- default is the protocol that is used in the original request.
    } deriving (Generic)

instance FromXML RedirectAllRequestsTo where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "RedirectAllRequestsTo"

instance ToXML RedirectAllRequestsTo where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "RedirectAllRequestsTo"

data RoutingRule = RoutingRule
    { _rrRedirect :: Redirect
      -- ^ Container for redirect information. You can redirect requests to
      -- another host, to another page, or with another protocol. In the
      -- event of an error, you can can specify a different error code to
      -- return.
    , _rrCondition :: Condition
      -- ^ A container for describing a condition that must be met for the
      -- specified redirect to apply. For example, 1. If request is for
      -- pages in the /docs folder, redirect to the /documents folder. 2.
      -- If request results in HTTP error 4xx, redirect request to another
      -- host where you might process the error.
    } deriving (Generic)

instance FromXML RoutingRule where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "RoutingRule"

instance ToXML RoutingRule where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "RoutingRule"

data Rule = Rule
    { _rStatus :: Switch ExpirationStatus
      -- ^ If 'Enabled', the rule is currently being applied. If 'Disabled',
      -- the rule is not currently being applied.
    , _rNoncurrentVersionExpiration :: NoncurrentVersionExpiration
      -- ^ Specifies when noncurrent object versions expire. Upon
      -- expiration, Amazon S3 permanently deletes the noncurrent object
      -- versions. You set this lifecycle configuration action on a bucket
      -- that has versioning enabled (or suspended) to request that Amazon
      -- S3 delete noncurrent object versions at a specific period in the
      -- object's lifetime.
    , _rTransition :: Transition
    , _rPrefix :: Text
      -- ^ Prefix identifying one or more objects to which the rule applies.
    , _rExpiration :: LifecycleExpiration
    , _rNoncurrentVersionTransition :: NoncurrentVersionTransition
      -- ^ Container for the transition rule that describes when noncurrent
      -- objects transition to the GLACIER storage class. If your bucket
      -- is versioning-enabled (or versioning is suspended), you can set
      -- this action to request that Amazon S3 transition noncurrent
      -- object versions to the GLACIER storage class at a specific period
      -- in the object's lifetime.
    , _rID :: Text
      -- ^ Unique identifier for the rule. The value cannot be longer than
      -- 255 characters.
    } deriving (Generic)

instance FromXML Rule where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Rule"

instance ToXML Rule where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Rule"

data Tag = Tag
    { _tValue :: Text
      -- ^ Value of the tag.
    , _tKey :: ObjectKey
      -- ^ Name of the tag.
    } deriving (Generic)

instance FromXML Tag where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Tag"

instance ToXML Tag where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Tag"

data TargetGrant = TargetGrant
    { _tgPermission :: BucketLogsPermission
      -- ^ Logging permissions assigned to the Grantee for the bucket.
    , _tgGrantee :: Grantee
    } deriving (Generic)

instance FromXML TargetGrant where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Grant"

instance ToXML TargetGrant where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Grant"

data TopicConfiguration = TopicConfiguration
    { _tcEvent :: Event
      -- ^ Bucket event for which to send notifications.
    , _tcTopic :: Text
      -- ^ Amazon SNS topic to which Amazon S3 will publish a message to
      -- report the specified events for the bucket.
    } deriving (Generic)

instance FromXML TopicConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "TopicConfiguration"

instance ToXML TopicConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "TopicConfiguration"

data Transition = Transition
    { _tDays :: Integer
      -- ^ Indicates the lifetime, in days, of the objects that are subject
      -- to the rule. The value must be a non-zero positive integer.
    , _tDate :: RFC822
      -- ^ Indicates at what date the object is to be moved or deleted.
      -- Should be in GMT ISO 8601 Format.
    , _tStorageClass :: TransitionStorageClass
      -- ^ The class of storage used to store the object.
    } deriving (Generic)

instance FromXML Transition where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "Transition"

instance ToXML Transition where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "Transition"

data VersioningConfiguration = VersioningConfiguration
    { _vcStatus :: Switch BucketVersioningStatus
      -- ^ The versioning state of the bucket.
    , _vcMfaDelete :: Switch MFADelete
      -- ^ Specifies whether MFA delete is enabled in the bucket versioning
      -- configuration. This element is only returned if the bucket has
      -- been configured with MFA delete. If the bucket has never been so
      -- configured, this element is not returned.
    } deriving (Generic)

instance FromXML VersioningConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "VersioningConfiguration"

instance ToXML VersioningConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "VersioningConfiguration"

data WebsiteConfiguration = WebsiteConfiguration
    { _wcRedirectAllRequestsTo :: RedirectAllRequestsTo
    , _wcErrorDocument :: ErrorDocument
    , _wcIndexDocument :: IndexDocument
    , _wcRoutingRules :: [RoutingRule]
    } deriving (Generic)

instance FromXML WebsiteConfiguration where
    fromXMLOptions = xmlOptions
    fromXMLRoot    = fromRoot "WebsiteConfiguration"

instance ToXML WebsiteConfiguration where
    toXMLOptions = xmlOptions
    toXMLRoot    = toRoot "WebsiteConfiguration"
