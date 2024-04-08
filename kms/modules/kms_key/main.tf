# Creates an AWS KMS key
resource "aws_kms_key" "my_kms_key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

}

# Creates an AWS KMS alias name
resource "aws_kms_alias" "my_alias" {
  name          = "alias/${var.aliases_name}"
  target_key_id = aws_kms_key.my_kms_key.arn
}
