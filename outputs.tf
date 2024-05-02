output "alb" {
  value = lookup(lookup(module.alb, "private", null), "aws_lb_listener", null)
}