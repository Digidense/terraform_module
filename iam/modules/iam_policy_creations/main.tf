# referred to the policy
locals {
  aws_managed_policies = {
    "AdministratorAccess" = data.aws_iam_policy_document.administrator_access.json
  }
}

#create the administrator policy
data "aws_iam_policy_document" "administrator_access" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

#Create the policy name and description
resource "aws_iam_policy" "policy" {
  count       = var.create_policy ? 1 : 0
  name        = var.name
  path        = var.path
  description = var.description
  policy      = local.aws_managed_policies[var.policy_name]
  tags        = var.tags
}

# Create the role
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

#Assume the role
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = var.create_policy ? 1 : 0
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.policy[count.index].arn
}
