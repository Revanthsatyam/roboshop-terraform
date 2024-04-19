module "components" {
  source = "git::https://github.com/Revanthsatyam/tf-module-basic-test.git"

  for_each = var.components
  vpc_security_group_ids = var.vpc_security_group_ids
  zone_id = var.zone_id
  instance_type = each.value["instance_type"]
  name = each.value["name"]
}
