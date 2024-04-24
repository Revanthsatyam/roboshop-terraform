vpc = {
  main = {
    cidr = "10.0.0.0/16"
    subnets = {
      public1 = { cidr = "10.0.0.0/16", az = "us-east-1a" }
      public2 = { cidr = "10.0.1.0/16", az = "us-east-1b" }
      app1 = { cidr = "10.0.2.0/16", az = "us-east-1a" }
      app2 = { cidr = "10.0.3.0/16", az = "us-east-1b" }
      db1 = { cidr = "10.0.2.0/16", az = "us-east-1a" }
      db2 = { cidr = "10.0.3.0/16", az = "us-east-1b" }
    }
  }
}