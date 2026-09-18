variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for app instances."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs the ASG launches instances into."
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN instances register with."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "ami_id" {
  description = "Specific AMI ID, or null to auto-discover."
  type        = string
  default     = null
}

variable "ami_name_pattern" {
  description = "AMI name pattern for auto-discovery."
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair name. null = none."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
}

variable "app_port" {
  description = "Port the application listens on (used in userdata)."
  type        = number
}

variable "instance_profile_arn" {
  description = "IAM instance profile ARN attached to instances."
  type        = string
}

variable "min_size" {
  description = "ASG minimum size."
  type        = number
}

variable "max_size" {
  description = "ASG maximum size."
  type        = number
}

variable "desired_capacity" {
  description = "ASG desired capacity."
  type        = number
}

variable "health_check_type" {
  description = "EC2 or ELB."
  type        = string
}

variable "health_check_grace_period" {
  description = "ASG health check grace period (seconds)."
  type        = number
}

variable "target_cpu" {
  description = "Target CPU % for target-tracking scaling."
  type        = number
}
