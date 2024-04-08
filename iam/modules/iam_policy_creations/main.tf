locals {
  aws_managed_policies = {
    "AdministratorAccess" = data.aws_iam_policy_document.administrator_access.json
  }
}

data "aws_iam_policy_document" "administrator_access" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  count       = var.create_policy ? 1 : 0
  name        = var.name
  path        = var.path
  description = var.description
  policy      = local.aws_managed_policies[var.policy_name]
  tags        = var.tags
}


resource "aws_iam_role" "iam_role" {
  name = var.iam_role_assume
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = var.create_policy ? 1 : 0
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy[count.index].arn
}
