resource "aws_iam_policy" "iam_policy" {
  name        = "sns_policy"
  description = "IAM policy for KMS, SNS, and S3 permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Statement for KMS
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
        ],
        Resource = "*",
      },
      # Statement for SNS
      {
        Effect = "Allow",
        Action = [
          "sns:Subscribe",
          "sns:Receive",
          "sns:DeleteMessage",
        ],
        Resource = "*",
      },
      # Statement for S3
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Resource = "*",
      },
    ],
  })
}

#Attach the role
resource "aws_iam_policy_attachment" "role_attachment" {
  name       = "sns_role_attachment"
  roles      = [aws_iam_role.iam_role.name]
  policy_arn = aws_iam_policy.iam_policy.arn
}

#create a iam role
resource "aws_iam_role" "iam_role" {
  name = "sns_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}