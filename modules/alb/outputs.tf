output "alb_arn" {
  description = "ARN of the ALB."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB."
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN of the ALB target group (ASG registers into this)."
  value       = aws_lb_target_group.app.arn
}

output "listener_arn" {
  description = "ARN of the ALB listener."
  value       = aws_lb_listener.http.arn
}