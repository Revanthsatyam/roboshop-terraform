module "vpc" {
  source = "git::https://github.com/Revanthsatyam/tf-module-vpc.git"

  for_each                   = var.vpc
  cidr                       = each.value["cidr"]
  subnets                    = each.value["subnets"]
  default_vpc_id             = var.default_vpc_id
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags                       = var.tags
  env                        = var.env
}

# module "alb" {
#   source = "git::https://github.com/Revanthsatyam/tf-module-alb.git"
#
#   for_each            = var.alb
#   internal            = each.value["internal"]
#   lb_type             = each.value["lb_type"]
#   sg_port             = each.value["sg_port"]
#   sg_ingress_cidr     = each.value["sg_ingress_cidr"]
#   vpc_id              = each.value["internal"] ? local.vpc_id : var.default_vpc_id
#   subnets             = each.value["internal"] ? local.app_subnets : data.aws_subnets.main.ids
#   tags                = var.tags
#   env                 = var.env
#   acm_certificate_arn = var.acm_certificate_arn
# }

module "docdb" {
  source = "git::https://github.com/Revanthsatyam/tf-module-docdb.git"
  tags   = var.tags
  env    = var.env

  for_each                = var.docdb
  subnet_ids              = local.db_subnets
  vpc_id                  = local.vpc_id
  sg_ingress_cidr         = local.app_subnets_cidr
  engine_family           = each.value["engine_family"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  engine_version          = each.value["engine_version"]
  instance_count          = each.value["instance_count"]
  instance_class          = each.value["instance_class"]
  kms_key_id              = var.kms_key_id
}

module "rds" {
  source = "git::https://github.com/Revanthsatyam/tf-module-rds.git"
  tags   = var.tags
  env    = var.env

  for_each                = var.rds
  subnet_ids              = local.db_subnets
  vpc_id                  = local.vpc_id
  sg_ingress_cidr         = local.app_subnets_cidr
  rds_type                = each.value["rds_type"]
  db_port                 = each.value["db_port"]
  engine_family           = each.value["engine_family"]
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  instance_count          = each.value["instance_count"]
  instance_class          = each.value["instance_class"]
  kms_key_id              = var.kms_key_id
}

module "elasticache" {
  source = "git::https://github.com/Revanthsatyam/tf-module-elasticache.git"
  tags   = var.tags
  env    = var.env

  for_each         = var.elasticache
  subnet_ids       = local.db_subnets
  vpc_id           = local.vpc_id
  sg_ingress_cidr  = local.app_subnets_cidr
  engine_family    = each.value["engine_family"]
  engine           = each.value["engine"]
  node_type        = each.value["node_type"]
  num_cache_nodes  = each.value["num_cache_nodes"]
  engine_version   = each.value["engine_version"]
  port             = each.value["port"]
  elasticache_type = each.value["elasticache_type"]
}

module "rabbitmq" {
  source  = "git::https://github.com/Revanthsatyam/tf-module-rabbitmq.git"
  tags    = var.tags
  env     = var.env
  zone_id = var.zone_id

  for_each         = var.rabbitmq
  subnet_id        = local.db_subnets
  vpc_id           = local.vpc_id
  sg_ingress_cidr  = local.app_subnets_cidr
  instance_type    = each.value["instance_type"]
  ssh_ingress_cidr = var.ssh_ingress_cidr
  kms_key_id       = var.kms_key_id
}

# module "app" {
#   depends_on = [module.alb, module.docdb, module.elasticache, module.rabbitmq, module.rds, module.vpc]
#   source     = "git::https://github.com/Revanthsatyam/tf-module-app.git"
#
#   tags                    = merge(var.tags, each.value["tags"])
#   env                     = var.env
#   zone_id                 = var.zone_id
#   ssh_ingress_cidr        = var.ssh_ingress_cidr
#   default_vpc_id          = var.default_vpc_id
#   monitoring_ingress_cidr = var.monitoring_ingress_cidr
#   kms_key_id              = var.kms_key_id
#
#   for_each         = var.app
#   component        = each.key
#   port             = each.value["port"]
#   instance_type    = each.value["instance_type"]
#   desired_capacity = each.value["desired_capacity"]
#   max_size         = each.value["max_size"]
#   min_size         = each.value["min_size"]
#   priority         = each.value["priority"]
#   parameters       = each.value["parameters"]
#
#
#   vpc_id          = local.vpc_id
#   sg_ingress_cidr = local.app_subnets_cidr
#   subnet_ids      = local.app_subnets
#
#   private_alb_name = lookup(lookup(lookup(module.alb, "private", null), "alb", null), "dns_name", null)
#   private_listener = lookup(lookup(lookup(module.alb, "private", null), "listener", null), "arn", null)
#   public_alb_name  = lookup(lookup(lookup(module.alb, "public", null), "alb", null), "dns_name", null)
#   public_listener  = lookup(lookup(lookup(module.alb, "public", null), "listener", null), "arn", null)
# }
#
# resource "aws_instance" "web" {
#   ami                    = data.aws_ami.ami.id
#   vpc_security_group_ids = ["sg-0f15c7e71393537f6"]
#   instance_type          = "t3.medium"
#
#   tags = {
#     Name = "load-runner"
#   }
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 19.0"
#
#   cluster_name    = "prod-roboshop"
#   cluster_version = "1.28"
#
#   cluster_endpoint_public_access  = false
#
#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }
#
#   vpc_id                   = local.vpc_id
#   subnet_ids               = local.app_subnets
#   control_plane_subnet_ids = local.app_subnets
#
#
#   eks_managed_node_groups = {
#     green = {
#       min_size     = 1
#       max_size     = 10
#       desired_size = 1
#
#       instance_types = ["t3.large"]
#       capacity_type  = "SPOT"
#     }
#   }
#
#   tags = var.tags
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "prod-roboshop"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = local.vpc_id
  subnet_ids               = local.app_subnets
  control_plane_subnet_ids = local.app_subnets

  eks_managed_node_groups = {
    Blue = {
      min_size     = 1
      max_size     = 10
      desired_size = 3

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true


  tags = var.tags
}

resource "aws_security_group_rule" "https-to-eks" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.ssh_ingress_cidr
  security_group_id = module.eks.cluster_security_group_id
}

resource "aws_iam_role" "test_role" {
  name = "${var.env}-eks-ssm-pm-ro"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "${var.env}-eks-ssm-ro"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt",
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "ssm:DescribeParameters",
          "Resource" : "*"
        }
      ]
    })
  }

}