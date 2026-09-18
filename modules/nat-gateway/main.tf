locals {
  # 1 NAT total (cost-optimised) or 1 per AZ (highly available)
  nat_count = var.single_nat_gateway ? 1 : length(var.public_subnet_ids)
}

resource "aws_eip" "nat" {
  count  = local.nat_count
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "this" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name = "${var.name_prefix}-nat-${count.index + 1}"
  }
}