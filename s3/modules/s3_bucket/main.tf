resource "aws_s3_bucket" "my_bucket" {
  bucket = "digidensebucket2024"
  acl    = "private"

}

resource "aws_s3_bucket_object" "my_object" {
  count = var.create ? 1 : 0

  bucket        = aws_s3_bucket.my_bucket.id
  key           = var.key
  force_destroy = var.force_destroy


  storage_class = try(upper(var.storage_class), var.storage_class)

  server_side_encryption = var.server_side_encryption
  kms_key_id             = var.kms_key_id
  bucket_key_enabled     = var.bucket_key_enabled

  source_hash = var.source_hash

  lifecycle {
    ignore_changes = [object_lock_retain_until_date]
  }
}

