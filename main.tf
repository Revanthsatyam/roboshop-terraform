module "components" {
  source = "git::https://github.com/Revanthsatyam/tf-module-vpc-test.git"

  for_each = var.vpc
  cidr     = each.value["cidr"]
  subnets = each.value["subnets"]
}