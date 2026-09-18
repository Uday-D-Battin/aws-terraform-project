variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (kept for context; NAT lives in a public subnet of this VPC)."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs to place the NAT Gateway(s) in."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "true = one NAT Gateway, false = one per public subnet/AZ."
  type        = bool
}