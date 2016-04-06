resource "aws_db_instance" "puppetdb_pgsql" {
  identifier           = "puppetdb-postgres"
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.4.5"
  instance_class       = "db.t2.medium"
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
