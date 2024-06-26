default_vpc_id             = "vpc-0704dade9610c31b7"
default_vpc_cidr           = "172.31.0.0/16"
default_vpc_route_table_id = "rtb-0da9b051f5b28b71b"
zone_id                    = "Z09651852G8MXYMFFQDTV"
env                        = "dev"
ssh_ingress_cidr           = ["172.31.16.110/32"]
monitoring_ingress_cidr    = ["172.31.20.88/32"]
acm_certificate_arn        = "arn:aws:acm:us-east-1:590183653013:certificate/9a857988-9301-4a9b-a0e5-563a71682a30"
kms_key_id                 = "arn:aws:kms:us-east-1:590183653013:key/86c6c9b1-d438-4118-a6c8-1ccc8fc4ce55"

vpc = {
  main = {
    cidr = "10.0.0.0/16"
    subnets = {
      public = {
        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
      }
      db = {
        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }
      }
    }
  }
}

tags = {
  company_name  = "ABC Tech"
  business_unit = "Ecommerce"
  project_name  = "robotshop"
  cost_center   = "ecom_rs"
  created_by    = "terraform"
}

alb = {
  public = {
    internal        = false
    lb_type         = "application"
    sg_port         = 443
    sg_ingress_cidr = ["0.0.0.0/0"]
  }
  private = {
    internal        = true
    lb_type         = "application"
    sg_port         = 80
    sg_ingress_cidr = ["10.0.0.0/16", "172.31.0.0/16"]
  }
}

docdb = {
  main = {
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    engine_family           = "docdb4.0"
    engine_version          = "4.0.0"
    instance_count          = 1
    instance_class          = "db.t3.medium"
  }
}

rds = {
  main = {
    rds_type                = "mysql"
    db_port                 = "3306"
    engine_family           = "aurora-mysql5.7"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.3"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    instance_count          = 1
    instance_class          = "db.t3.small"
  }
}

elasticache = {
  main = {
    elasticache_type = "redis"
    engine_family    = "redis6.x"
    port             = 6379
    engine           = "redis"
    node_type        = "cache.t3.micro"
    num_cache_nodes  = 1
    engine_version   = "6.2"
  }
}

rabbitmq = {
  main = {
    instance_type = "t3.small"
  }
}

app = {
  frontend = {
    instance_type    = "t3.micro"
    port             = 80
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 1
    parameters       = ["nexus"]
    tags = { Monitor_Nginx = "yes" }
  }
  catalogue = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 2
    parameters       = ["docdb", "nexus"]
    tags = {}
  }
  user = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 3
    parameters       = ["docdb", "nexus"]
    tags = {}
  }
  cart = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 4
    parameters       = ["nexus"]
    tags = {}
  }
  payment = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 5
    parameters       = ["rabbitmq", "nexus"]
    tags = {}
  }
  shipping = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    priority         = 6
    parameters       = ["rds", "nexus"]
    tags = {}
  }
}
