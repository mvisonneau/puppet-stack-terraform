#
# SECURITY GROUPS
#

#
# ELBs SGs
#

# PUPPETCA ELB
resource "aws_security_group" "puppetca_elb" {
  name        = "${var.owner}_puppet_puppetca_elb_sg"
  description = "Puppet CA ELB SG"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTPS FROM ALL
  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ALLOW OUTBAND TRAFFIC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_puppet_puppetca_elb_sg"
    Owner = "${var.owner}"
  }
}

# PUPPETDB ELB
resource "aws_security_group" "puppetdb_elb" {
  name        = "${var.owner}_puppet_puppetdb_elb_sg"
  description = "Puppet DB ELB SG"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTPS FROM ALL
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ALLOW OUTBAND TRAFFIC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_puppet_puppetdb_elb_sg"
    Owner = "${var.owner}"
  }
}

#
# INSTANCES SGs
#

# DEFAULT SG
resource "aws_security_group" "default" {
  name = "${var.owner}_puppet_default_sg"
  description = "Default SG for Puppet VPC"
  vpc_id = "${aws_vpc.default.id}"

  # SSH WITHIN THE VPC
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  # ICMP WITHIN THE VPC
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  # ALLOW OUTBAND TRAFFIC
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_puppet_default_sg"
    Owner = "${var.owner}"
  }
}

# JUMP HOST SG
resource "aws_security_group" "jump" {
  name = "${var.owner}_puppet_jump_sg"
  description = "Manages Jump host traffic"
  vpc_id = "${aws_vpc.default.id}"

  # SSH FROM ALL
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_puppet_jump_sg"
    Owner = "${var.owner}"
  }
}

# PUPPETDB SG
resource "aws_security_group" "puppetdb" {
  name        = "${var.owner}_puppet_puppetdb_sg"
  description = "Puppet DB SG"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTPS FROM VPC
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  tags {
    Name  = "${var.owner}_puppet_puppetdb_sg"
    Owner = "${var.owner}"
  }
}

# PUPPETCA SG
resource "aws_security_group" "puppetca" {
  name        = "${var.owner}_puppet_puppetca_sg"
  description = "Puppet DB SG"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTPS FROM VPC
  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  tags {
    Name  = "${var.owner}_puppet_puppetca_sg"
    Owner = "${var.owner}"
  }
}
