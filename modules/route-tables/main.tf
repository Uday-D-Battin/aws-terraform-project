locals {
  private_rt_count = var.single_nat_gateway ? 1 : length(var.private_subnet_ids)
}

# ---------------- Public: default route -> IGW ----------------

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" # the default route — intentional, not a hardcoded value
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# ---------------- Private: default route -> NAT ----------------
# One private route table per AZ when NAT-per-AZ, otherwise one shared table.

resource "aws_route_table" "private" {
  count = local.private_rt_count

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-private-rt-${count.index + 1}"
  }

  lifecycle {
    precondition {
      condition     = var.single_nat_gateway || length(var.nat_gateway_ids) >= length(var.private_subnet_ids)
      error_message = "Need one NAT Gateway per AZ when single_nat_gateway = false."
    }
  }
}

resource "aws_route" "private_default" {
  count = local.private_rt_count

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index]
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[var.single_nat_gateway ? 0 : count.index].id
}