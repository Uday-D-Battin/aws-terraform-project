variable "name_prefix" {
  description = "Prefix applied to resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID the route tables belong to."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs to associate with the public route table."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to associate with private route tables."
  type        = list(string)
}

variable "igw_id" {
  description = "Internet Gateway ID used for the public default route."
  type        = string
}

variable "nat_gateway_ids" {
  description = "NAT Gateway IDs used for private default routes."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Whether a single NAT Gateway is shared across AZs."
  type        = bool
}