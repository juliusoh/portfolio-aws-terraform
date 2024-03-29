data "aws_availability_zones" "available" {
}

resource "aws_vpc" "mod" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.stack_name
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = aws_vpc.mod.id

  tags = {
    Name = "${var.stack_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id           = aws_vpc.mod.id
  propagating_vgws = var.public_propagating_vgws

  tags = {
    Name = "${var.stack_name}-rt-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mod.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

resource "aws_route_table" "private" {
  vpc_id           = aws_vpc.mod.id
  propagating_vgws = var.private_propagating_vgws
  count            = length(var.private_subnets)

  tags = {
    Name = "${var.stack_name}-rt-private-${data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]}"
  }
}


resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.mod.id
  cidr_block        = element(concat(var.private_subnets), count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.stack_name}-subnet-private-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/cluster/tf-${var.stack_name}-eks-cluster-${var.region}" = "owned"
  }
}
resource "aws_subnet" "eks" {
  count = length(var.eks_subnets)

  vpc_id            = aws_vpc.mod.id
  cidr_block        = element(concat(var.eks_subnets), count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.stack_name}-subnet-eks-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/cluster/tf-${var.stack_name}-eks-cluster-${var.region}" = "owned"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.mod.id
  cidr_block        = element(concat(var.public_subnets), count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.stack_name}-subnet-public-${element(data.aws_availability_zones.available.names, count.index)}"
    "kubernetes.io/cluster/tf-${var.stack_name}-eks-cluster-${var.region}" = "owned"
  }

  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_eip" "nateip" {
  vpc   = true
  count = 1
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateip[0].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.mod]
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
resource "aws_route_table_association" "eks" {
  count          = length(var.eks_subnets)
  subnet_id      = element(aws_subnet.eks.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}