resource "aws_db_instance" "puppetdb_pgsql" {
  identifier           = "puppetdb-postgres"
  allocated_storage    = "${var.rds_size}"
  engine               = "postgres"
  engine_version       = "${var.rds_version}"
  instance_class       = "${var.rds_instance}"
  name                 = "puppetdb"
  username             = "puppetdb"
  password             = "puppetdb"
  multi_az             = false
  maintenance_window   = "Sun:00:00-Sun:03:00"
  db_subnet_group_name = "${aws_db_subnet_group.puppetdb_pgsql.name}"
}

resource "aws_db_subnet_group" "puppetdb_pgsql" {
  name = "puppetdb_pgsql_private_subnet"
  description = "PuppetDB Private Subnet"
  subnet_ids = ["${aws_subnet.private_subnet.*.id}"]
}
