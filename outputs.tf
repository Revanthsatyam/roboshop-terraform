output "alb" {
  value = lookup(lookup(lookup(module.alb, "private", null), "alb", null), "aws_lb_listener", null)
}