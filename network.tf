#
# VPC
#
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name     = "${var.owner}_puppet_vpc"
    Owner    = "${var.owner}"
  }
}

#
# EIPs
#
resource "aws_eip" "natgw" {
  vpc   = true
  count = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
}

#
# SUBNETS
#

# PUBLIC SUBNETS
resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet( var.vpc_cidr, var.subnet_bits, count.index )}"
  availability_zone = "${var.region}${element( split( ",", lookup( var.azs, var.region ) ), count.index )}"
  count             = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name            = "${var.owner}_puppet_public_subnet_${element( split( ",", lookup( var.azs, var.region ) ), count.index )}"
    Owner           = "${var.owner}"
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private_subnet" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet( var.vpc_cidr, var.subnet_bits, ( length( split( ",", lookup( var.azs, var.region ) ) ) + count.index ) )}"
  availability_zone = "${var.region}${element( split( ",", lookup( var.azs, var.region ) ), count.index )}"
  count             = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name            = "${var.owner}_puppet_private_subnet_${element( split( ",", lookup( var.azs, var.region ) ), count.index )}"
    Owner           = "${var.owner}"
  }
}

#
# GATEWAYS
#

# INTERNET GW
resource "aws_internet_gateway" "default_igw" {
  vpc_id    = "${aws_vpc.default.id}"
  tags {
    Name    = "${var.owner}_puppet_igw"
    Owner   = "${var.owner}"
  }
}

# NAT GW
resource "aws_nat_gateway" "default_natgw" {
  allocation_id = "${element( aws_eip.natgw.*.id, count.index )}"
  subnet_id     = "${element( aws_subnet.public_subnet.*.id, count.index )}"
  count         = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  depends_on    = ["aws_internet_gateway.default_igw"]
  # Tags not supported
}

#
# ROUTES
#

# DEFAULT ROUTE TO IGW
resource "aws_route_table" "default_to_igw" {
  vpc_id       = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default_igw.id}"
  }
  tags {
    Name       = "${var.owner}_puppet_default_to_igw"
    Owner      = "${var.owner}"
  }
}

resource "aws_route_table" "default_to_natgw" {
  vpc_id           = "${aws_vpc.default.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element( aws_nat_gateway.default_natgw.*.id, count.index )}"
  }
  count            = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name           = "${var.owner}_puppet_default_to_natgw_${element( split( ",", lookup( var.azs, var.region ) ), count.index )}"
    Owner          = "${var.owner}"
  }
}

resource "aws_route_table_association" "public_subnet_and_default_to_igw" {
  subnet_id      = "${element( aws_subnet.public_subnet.*.id, count.index )}"
  route_table_id = "${aws_route_table.default_to_igw.id}"
  count          = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  # Tags not supported
}

resource "aws_route_table_association" "private_subnet_and_default_to_natgw" {
  subnet_id      = "${element( aws_subnet.private_subnet.*.id, count.index )}"
  route_table_id = "${element( aws_route_table.default_to_natgw.*.id, count.index )}"
  count          = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  # Tags not supported
}
