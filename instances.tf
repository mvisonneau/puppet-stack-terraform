#
# Puppet CA Instance
#
resource "aws_instance" "puppetca" {
  ami                         = "${lookup( var.amis_ubuntu_140404, var.region )}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element( aws_subnet.private_subnet.*.id, count.index )}"
  key_name                    = "${aws_key_pair.default.key_name}"
  /*ebs_block_device {
    device_name               = "/dev/sdb"
    volume_type               = "io1"
    iops                      = 1000
    encrypted                 = true
    volume_size               = 1
    delete_on_termination     = false
  }*/
  security_groups             = ["${aws_security_group.default.id}","${aws_security_group.puppetca.id}"]
  tags {
    Name                      = "${var.owner}_puppetca_${count.index+1}"
    owner                     = "${var.owner}"
  }
}

#
# Puppet DB Instances
#
resource "aws_instance" "puppetdb" {
  ami                         = "${lookup( var.amis_ubuntu_140404, var.region )}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element( aws_subnet.private_subnet.*.id, count.index )}"
  key_name                    = "${aws_key_pair.default.key_name}"
  security_groups             = ["${aws_security_group.default.id}","${aws_security_group.puppetdb.id}"]
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name                      = "${var.owner}_puppetdb_${count.index+1}"
    owner                     = "${var.owner}"
  }
}

#
# Jump host
#
resource "aws_instance" "jump" {
  ami                         = "${lookup( var.amis_ubuntu_140404, var.region )}"
  instance_type               = "t2.nano"
  subnet_id                   = "${element( aws_subnet.public_subnet.*.id, count.index )}"
  key_name                    = "${aws_key_pair.default.key_name}"
  security_groups             = ["${aws_security_group.default.id}","${aws_security_group.jump.id}"]
  associate_public_ip_address = true
  tags {
    Name                      = "${var.owner}_jump_${count.index+1}"
    owner                     = "${var.owner}"
  }
}
