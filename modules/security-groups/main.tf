# Rule rules are separate resources (aws_vpc_security_group_*_rule)
# to avoid circular dependencies between the ALB and app SGs.

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB: inbound only on the listener port, from approved CIDRs"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "App: inbound only on the app port, only from the ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-app-sg"
  }
}

# ---------------- Ingress ----------------

# Internet -> ALB, listener port only, only from allowed CIDRs
resource "aws_vpc_security_group_ingress_rule" "alb_from_allowed_cidrs" {
  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  description       = "Listener port from approved CIDRs only"

  cidr_ipv4   = each.value
  ip_protocol = "tcp"
  from_port   = var.alb_listener_port
  to_port     = var.alb_listener_port
}

# ALB -> App: app port, referenced by SG (not CIDR)
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id
  description       = "App port from the ALB security group only"

  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

# ---------------- Egress ----------------

# ALB may ONLY talk to app instances on the app port — nothing else
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id
  description       = "Only reach app instances on the app port"

  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

# App: outbound web only (repos/SSM), no all-ports/all-protocols egress
resource "aws_vpc_security_group_egress_rule" "app_https" {
  for_each = toset(var.app_egress_cidrs)

  security_group_id = aws_security_group.app.id
  description       = "HTTPS egress (updates, APIs, SSM)"

  cidr_ipv4   = each.value
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "app_http" {
  for_each = toset(var.app_egress_cidrs)

  security_group_id = aws_security_group.app.id
  description       = "HTTP egress (package repositories)"

  cidr_ipv4   = each.value
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}