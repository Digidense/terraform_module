module "kms_module" {
  source                  = "./modules/kms_key"
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  aliases_name            = var.aliases_name

}

