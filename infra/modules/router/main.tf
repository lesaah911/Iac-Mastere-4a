locals {
  prefix = "${var.username}-${var.environment}"
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.local_network_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = var.extra_network_cidr
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "${local.prefix}-route-table"
  }
}
