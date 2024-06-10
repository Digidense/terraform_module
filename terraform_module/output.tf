output "vpc_id" {
  value = module.vpc_module.vpc_id
}

output "subnet_pri01_id" {
  value = module.vpc_module.subnet_pri01
}

output "subnet_pri02_id" {
  value = module.vpc_module.subnet_pri02
}

output "security_group_id" {
  value = module.vpc_module.security_group_id
}