# ------------------------------------------------------------------
# Global
# ------------------------------------------------------------------
aws_region   = "ap-south-1"
project_name = "uday"        # keep short: used in ALB/TG names (32 char limit)
environment  = "poc"

# ------------------------------------------------------------------
# Network (AZs auto-discovered; set `azs = ["ap-south-1a","ap-south-1b"]` to pin them)
# ------------------------------------------------------------------
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
single_nat_gateway    = true       # true = cheaper; false = 1 NAT per AZ (HA)

# ------------------------------------------------------------------
# Ports / security
# ------------------------------------------------------------------
allowed_ingress_cidrs = ["0.0.0.0/0"]   # PROD: restrict to your IP range, e.g. ["203.0.113.5/32"]
alb_listener_port     = 80
app_port              = 8080

# ------------------------------------------------------------------
# Compute
# ------------------------------------------------------------------
instance_type                  = "t3.micro"
ami_name_pattern               = "al2023-ami-*-x86_64"   # latest Amazon Linux 2023
root_volume_size               = 8
asg_min_size                   = 2
asg_max_size                   = 6
asg_desired_capacity           = 2
asg_health_check_type          = "ELB"
asg_health_check_grace_period  = 300
target_cpu                     = 50
# key_name                     = "my-keypair"             # optional, omit for SSM-only access

# ------------------------------------------------------------------
# ALB health checks
# ------------------------------------------------------------------
health_check_path        = "/health"
health_check_interval    = 30
health_check_timeout     = 5
healthy_threshold        = 3
unhealthy_threshold      = 3
enable_deletion_protection = false