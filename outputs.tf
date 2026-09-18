output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.subnets.private_subnet_ids
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB."
  value       = module.alb.alb_dns_name
}

output "app_url" {
  description = "URL to reach the application through the ALB."
  value       = "http://${module.alb.alb_dns_name}"
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.compute.asg_name
}

output "alb_security_group_id" {
  value = module.security_groups.alb_sg_id
}

output "app_security_group_id" {
  value = module.security_groups.app_sg_id
}