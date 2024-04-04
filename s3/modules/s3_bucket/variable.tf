variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "The name of the bucket to put the file in. Alternatively, an S3 access point ARN can be specified."
  type        = string
  default     = "digidensebucket2024"
}

variable "key" {
  description = "The name of the object once it is in the bucket."
  type        = string
  default     = "objecting"
}

variable "acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control. Defaults to private."
  type        = string
  default     = "public-read"
}
variable "storage_class" {
  description = "Specifies the desired Storage Class for the object. Can be either STANDARD, REDUCED_REDUNDANCY, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE, or STANDARD_IA. Defaults to STANDARD."
  type        = string
  default     = null
}

variable "server_side_encryption" {
  description = "Specifies server-side encryption of the object in S3. Valid values are \"AES256\" and \"aws:kms\"."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Amazon Resource Name (ARN) of the KMS Key to use for object encryption. If the S3 Bucket has server-side encryption enabled, that value will automatically be used. If referencing the aws_kms_key resource, use the arn attribute. If referencing the aws_kms_alias data source or resource, use the target_key_arn attribute. Terraform will only perform drift detection if a configuration value is provided."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
  type        = bool
  default     = null
}

variable "force_destroy" {
  description = "Allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
  type        = bool
  default     = false
}


variable "source_hash" {
  description = "Triggers updates like etag but useful to address etag encryption limitations. Set using filemd5(\"path/to/source\") (Terraform 0.11.12 or later). (The value is only stored in state and not saved by AWS.)"
  type        = string
  default     = null
}

variable "override_default_tags" {
  description = "Ignore provider default_tags. S3 objects support a maximum of 10 tags."
  type        = bool
  default     = false
}


variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}
