# ------------------------------------------------------------------
# Global
# ------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
}

variable "project_name" {
  description = "Short project name used as a prefix everywhere (ALB/TG names max 32 chars)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev / staging / prod)."
  type        = string
}

# ------------------------------------------------------------------
# Network
# ------------------------------------------------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones to use. Leave null to auto-discover the first N AZs of the region."
  type        = list(string)
  default     = null
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per AZ."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "At least 2 public subnets are required (ALB needs one per AZ)."
  }
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per AZ."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2
    error_message = "At least 2 private subnets are required for HA."
  }
}

variable "single_nat_gateway" {
  description = "true = 1 NAT Gateway (cheaper). false = 1 NAT Gateway per AZ (HA)."
  type        = bool
}

# ------------------------------------------------------------------
# Ports / security
# ------------------------------------------------------------------
variable "alb_listener_port" {
  description = "Port the ALB listens on."
  type        = number
}

variable "app_port" {
  description = "Port the application listens on (also the ALB target port)."
  type        = number
}

variable "allowed_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB. Restrict to your office/VPN range in production."
  type        = list(string)
}

# ------------------------------------------------------------------
# Compute
# ------------------------------------------------------------------
variable "instance_type" {
  description = "EC2 instance type for the application tier."
  type        = string
}

variable "ami_id" {
  description = "Specific AMI ID to use. Leave null to auto-discover the latest Amazon Linux 2023 AMI."
  type        = string
  default     = null
}

variable "ami_name_pattern" {
  description = "AMI name pattern for auto-discovery (used only when ami_id is null)."
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair for emergency SSH. null = no key (use SSM Session Manager)."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size (GB) for app instances."
  type        = number
}

variable "asg_min_size" {
  description = "Minimum number of instances in the ASG."
  type        = number

  validation {
    condition     = var.asg_min_size >= 2
    error_message = "Minimum size must be at least 2 for high availability."
  }
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the ASG."
  type        = number
}

variable "asg_health_check_type" {
  description = "ASG health check type: ELB (ALB target health) or EC2."
  type        = string

  validation {
    condition     = contains(["EC2", "ELB"], var.asg_health_check_type)
    error_message = "Allowed values: EC2 or ELB."
  }
}

variable "asg_health_check_grace_period" {
  description = "Seconds ASG waits before checking instance health after launch."
  type        = number
}

variable "target_cpu" {
  description = "Target average CPU (%) for the ASG target-tracking scaling policy."
  type        = number
}

# ------------------------------------------------------------------
# ALB / target group health checks
# ------------------------------------------------------------------
variable "health_check_path" {
  description = "HTTP path used for target health checks."
  type        = string
}

variable "health_check_interval" {
  description = "Seconds between health checks."
  type        = number
}

variable "health_check_timeout" {
  description = "Seconds before a health check times out."
  type        = number
}

variable "healthy_threshold" {
  description = "Consecutive successes to mark a target healthy."
  type        = number
}

variable "unhealthy_threshold" {
  description = "Consecutive failures to mark a target unhealthy."
  type        = number
}

variable "enable_deletion_protection" {
  description = "Protect the ALB from accidental deletion."
  type        = bool
}