#create a iam policy
resource "aws_iam_policy" "iam_policy" {
  name        = var.name[0]
  description = "IAM policy for KMS, SNS, and S3 permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:*",
          "sns:*",
          "s3:*",
        ],
        Resource = "*",
      },
    ],
  })
}

#Attach the role
resource "aws_iam_policy_attachment" "role_attachment" {
  name       = var.name[1]
  roles      = [aws_iam_role.iam_role.name]
  policy_arn = "arn:aws:iam::105787501323:policy/iam_policy"
}

#create a iam role
resource "aws_iam_role" "iam_role" {
  name = var.name[2]
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}