#output "vpc" {
#  value = module.vpc
#}

output "subnet_ids" {
  value = data.aws_subnets.main
}