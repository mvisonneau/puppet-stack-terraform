resource "aws_db_instance" "puppetdb_pgsql" {
  identifier              = "puppetdb-postgres"
  allocated_storage       = "${var.rds_size}"
  engine                  = "postgres"
  engine_version          = "${var.rds_version}"
  port                    = "5432"
  instance_class          = "${var.rds_instance}"
  name                    = "${var.rds_name}"
  username                = "${var.rds_username}"
  password                = "${var.rds_password}"
  multi_az                = "${var.rds_multi_az}"
  maintenance_window      = "${var.rds_maintenance_window}"
  backup_window           = "${var.rds_backup_window}"
  backup_retention_period = "${var.rds_backup_retention_period}"
  db_subnet_group_name    = "${aws_db_subnet_group.puppetdb_pgsql.name}"
}

resource "aws_db_subnet_group" "puppetdb_pgsql" {
  name = "puppetdb_pgsql_private_subnet"
  description = "PuppetDB Private Subnet"
  subnet_ids = ["${aws_subnet.private_subnet.*.id}"]
}
