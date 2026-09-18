variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID the security groups belong to."
  type        = string
}

variable "alb_listener_port" {
  description = "Port the ALB listens on (inbound rule for the ALB SG)."
  type        = number
}

variable "app_port" {
  description = "Application port (inbound rule for the app SG, ALB egress rule)."
  type        = number
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB."
  type        = list(string)
}

variable "app_egress_cidrs" {
  description = "Destination CIDRs app instances may reach over HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}