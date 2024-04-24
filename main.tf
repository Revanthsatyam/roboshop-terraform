module "components" {
  source = "git::https://github.com/Revanthsatyam/tf-module-vpc.git"

  cidr = var.cidr
}
