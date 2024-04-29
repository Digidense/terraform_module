# vpc module refer for sg and subnet
module "vpc_module_rds" {
  source = "git::https://github.com/Digidense/terraform_module.git//vpc?ref=feature/DD-42-VPC_module"
}

# secret manager creation
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days
  tags = {
    Name = var.secret-tags
  }
}

# secret manager version creation
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_username_password
  })
}

# creating the rds database
resource "aws_db_instance" "example" {
  identifier                 = var.db_name
  instance_class             = var.instance_class
  engine                     = var.engine_name
  engine_version             = var.engine_version
  allocated_storage          = 20
  storage_type               = var.storage_type
  username                   = var.db_username
  password                   = var.db_username_password
  parameter_group_name       = var.parameter_group_name
  publicly_accessible        = var.value_f
  multi_az                   = var.value_t
  backup_retention_period    = 7
  backup_window              = var.backup_window
  auto_minor_version_upgrade = var.value_t
  db_subnet_group_name       = aws_db_subnet_group.example.name
  skip_final_snapshot        = var.value_t # Skip the final snapshot
  #  final_snapshot_identifier  = "unique-db-snapshot"
  vpc_security_group_ids = [module.vpc_module_rds.security_group_id]
  tags = {
    Name        = var.tag_name[0].name
    Environment = var.tag_name[0].environment
  }
}

# subnet refer from the module block
resource "aws_db_subnet_group" "example" {
  name = var.aws_db_subnet_group
  subnet_ids = [
    module.vpc_module_rds.subnet_pri01,
    module.vpc_module_rds.subnet_pri02
  ]
}

# IAM Authentication for application user
resource "aws_iam_user" "application_user" {
  name = var.application_user
}

# policy attached to application user
resource "aws_iam_user_policy_attachment" "application_user_policy" {
  user       = aws_iam_user.application_user.name
  policy_arn = var.policy
}