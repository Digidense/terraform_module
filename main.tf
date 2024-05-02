resource "aws_iam_user" "org-admin-users" {
  name = "user1"
}
resource "aws_iam_user_policy_attachment" "example_user_policy_attachment" {
  user       = aws_iam_user.org-admin-users.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_user_login_profile" "org-admin-users-login-profile" {
  user                    = aws_iam_user.org-admin-users.name
  password_length         = 10
  password_reset_required = false
}
output "Password" {
  value = aws_iam_user_login_profile.org-admin-users-login-profile.password
}

