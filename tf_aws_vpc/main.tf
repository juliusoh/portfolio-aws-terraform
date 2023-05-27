resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "subnets_public" {
  depends_on = [aws_vpc.vpc]

  for_each = {
    for i, v in var.subnets : i => v

    if v.type == "public"
  }
  cidr_block = each.value.cidr_block
  tags = {
    Name = each.value.name
  }
  availability_zone       = join("", [var.region, each.value.az])
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnets_private" {
  depends_on = [aws_vpc.vpc]
  for_each = {
    for i, v in var.subnets : i => v

    if v.type == "private"
  }
  cidr_block = each.value.cidr_block
  tags = {
    Name = each.value.name
  }
  availability_zone = join("", [var.region, each.value.az])
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_route_table" "rt_public" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table" "rt_private" {
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "nat_rt_entry" {
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "rt_private_association" {
  for_each       = { for i, v in aws_subnet.subnets_private : i => v }
  subnet_id      = aws_subnet.subnets_private[each.key].id
  route_table_id = aws_route_table.rt_private.id
}
resource "aws_route_table_association" "rt_public_association" {
  for_each       = { for i, v in aws_subnet.subnets_public : i => v }
  subnet_id      = aws_subnet.subnets_public[each.key].id
  route_table_id = aws_route_table.rt_public.id
}
