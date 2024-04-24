# This module sets up a KMS module attachment for ECR encryption
module "Kms_module" {
  source                  = "git::https://github.com/Digidense/terraform_module.git//kms?ref=v1.0.0"
  aliases_name            = var.aliases_name
  deletion_window_in_days = var.deletion_day
  enable_key_rotation     = var.enable_key_rotation
}

// IAM Role for ECR Push
resource "aws_iam_role" "ecr_push_role" {
  name = var.policy_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecr.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

// IAM Policy for ECR Push
resource "aws_iam_policy" "ecr_push_policy" {
  name        = var.ecr-push-policy
  description = "Policy to allow pushing images to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      Resource = aws_ecr_repository.ecr.arn
    }]
  })
}

//IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecr_push_policy_attachment" {
  role       = aws_iam_role.ecr_push_role.name
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}

// ECR Repository Creation
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr-name
  image_tag_mutability = var.mutable
  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = module.Kms_module.kms_key_arn
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}
