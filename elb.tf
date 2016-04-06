#
# ELBs
#

# PUPPET CA
resource "aws_elb" "puppetca" {
  subnets                     = ["${aws_subnet.public_subnet.*.id}"]
  name                        = "${var.owner}-puppetca"

  listener {
    instance_port             = 8040
    instance_protocol         = "tcp"
    lb_port                   = 8040
    lb_protocol               = "tcp"
  }

  instances                   = ["${aws_instance.puppetca.*.id}"]
  security_groups             = ["${aws_security_group.puppetca_elb.id}"]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name                      = "${var.owner}_puppet_elb_puppetca"
    owner                     = "${var.owner}"
  }
}

# PUPPET DB
resource "aws_elb" "puppetdb" {
  subnets                     = ["${aws_subnet.public_subnet.*.id}"]
  name                        = "${var.owner}-puppetdb"

  listener {
    instance_port             = 8081
    instance_protocol         = "tcp"
    lb_port                   = 8081
    lb_protocol               = "tcp"
  }

  /*health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8081/"
    interval = 30
  }*/

  instances                   = ["${aws_instance.puppetdb.*.id}"]
  security_groups             = ["${aws_security_group.puppetdb_elb.id}"]
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name                      = "${var.owner}_puppet_elb_puppetdb"
    owner                     = "${var.owner}"
  }
}
