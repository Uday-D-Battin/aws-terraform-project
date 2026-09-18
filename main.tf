data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  subnet_count = length(var.public_subnet_cidrs)
  azs          = var.azs != null ? var.azs : slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
}

# ==================================================================
# NETWORK LAYER
# ==================================================================

module "vpc" {
  source      = "./modules/vpc"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
}

module "subnets" {
  source               = "./modules/subnets"
  name_prefix          = local.name_prefix
  vpc_id               = module.vpc.vpc_id
  azs                  = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "internet_gateway" {
  source      = "./modules/internet-gateway"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

module "nat_gateway" {
  source             = "./modules/nat-gateway"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  single_nat_gateway = var.single_nat_gateway
}

module "route_tables" {
  source             = "./modules/route-tables"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  igw_id             = module.internet_gateway.igw_id
  nat_gateway_ids    = module.nat_gateway.nat_gateway_ids
  single_nat_gateway = var.single_nat_gateway
}

# SECURITY (least privilege) 

module "security_groups" {
  source                = "./modules/security-groups"
  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  alb_listener_port     = var.alb_listener_port
  app_port              = var.app_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = local.name_prefix
}

# ==================================================================
# APPLICATION LAYER
# ==================================================================

module "alb" {
  source       = "./modules/alb"
  name_prefix  = local.name_prefix
  vpc_id       = module.vpc.vpc_id
  alb_sg_id    = module.security_groups.alb_sg_id
  public_subnet_ids = module.subnets.public_subnet_ids

  app_port      = var.app_port
  listener_port = var.alb_listener_port

  health_check_path          = var.health_check_path
  health_check_interval      = var.health_check_interval
  health_check_timeout       = var.health_check_timeout
  healthy_threshold          = var.healthy_threshold
  unhealthy_threshold        = var.unhealthy_threshold
  enable_deletion_protection = var.enable_deletion_protection
}

module "compute" {
  source       = "./modules/compute"
  name_prefix  = local.name_prefix
  app_sg_id    = module.security_groups.app_sg_id
  private_subnet_ids = module.subnets.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn

  instance_type         = var.instance_type
  ami_id                = var.ami_id
  ami_name_pattern      = var.ami_name_pattern
  key_name              = var.key_name
  root_volume_size      = var.root_volume_size
  app_port              = var.app_port
  instance_profile_arn  = module.iam.instance_profile_arn

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period
  target_cpu                = var.target_cpu

  # Instances bootstrap through the NAT Gateway (dnf install),
  # so make sure NAT + routes exist before the ASG launches anything.
  depends_on = [module.route_tables, module.nat_gateway]
}