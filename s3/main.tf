module "Kms_module" {
  source                  = "git::https://github.com/Digidense/terraform_module.git//kms?ref=feature/DD-35/kms_module"
  aliases_name            = "alias/Kms_S3_Module"
  description             = "kms module attachment"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "digidensebucket2024"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = module.Kms_module.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "log-files"
    enabled = true

    prefix = "logs/"

    expiration {
      days = 90
    }
  }
}
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3_bucket_policy"
  description = "IAM policy for S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      },

    ]
  })
}
