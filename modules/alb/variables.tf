variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group."
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID attached to the ALB."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs (one per AZ) the ALB is attached to."
  type        = list(string)
}

variable "app_port" {
  description = "Application port — target group port."
  type        = number
}

variable "listener_port" {
  description = "ALB listener port."
  type        = number
}

variable "health_check_path" {
  description = "HTTP path used for health checks."
  type        = string
}

variable "health_check_interval" {
  description = "Seconds between health checks."
  type        = number
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds."
  type        = number
}

variable "healthy_threshold" {
  description = "Successes required to be healthy."
  type        = number
}

variable "unhealthy_threshold" {
  description = "Failures required to be unhealthy."
  type        = number
}

variable "health_check_matcher" {
  description = "HTTP status code(s) that mean healthy."
  type        = string
  default     = "200"
}

variable "enable_deletion_protection" {
  description = "Enable ALB deletion protection."
  type        = bool
}