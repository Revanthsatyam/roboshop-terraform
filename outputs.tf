#output "vpc" {
#  value = module.vpc
#}

output "subnets_app" {
  value = local.app_subnets
}