module "s3_module" {
  source = "./modules/s3_bucket"
  create = var.create
  bucket_name = var.bucket_name
  key = var.key
  acl = var.acl
  storage_class = var.storage_class
  server_side_encryption = var.server_side_encryption
  kms_key_id = var.kms_key_id
  bucket_key_enabled = var.bucket_key_enabled
  force_destroy = var.force_destroy
  override_default_tags = var.override_default_tags
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}