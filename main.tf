provider "aws" {
  region = var.region
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier = var.instance.name

  engine            = var.instance.engine
  engine_mode       = var.instance.engine_mode
  engine_version    = var.instance.engine_version
  storage_encrypted = var.instance.encrypted

  database_name   = var.instance.name
  master_username = var.instance.username
  master_password = var.instance.password
  port            = var.instance.port

  vpc_security_group_ids          = var.security_groups
  db_subnet_group_name            = var.subnet
  db_cluster_parameter_group_name = var.params

  final_snapshot_identifier = var.instance.final_snapshot_identifier
  skip_final_snapshot       = var.instance.skip_final_snapshot
  deletion_protection       = var.instance.deletion_protection

  backup_retention_period      = var.instance.backup_period
  preferred_backup_window      = var.instance.backup_window
  preferred_maintenance_window = var.instance.maintenance_window

  snapshot_identifier                 = var.instance.snapshot_identifier
  apply_immediately                   = var.instance.apply_immediately
  iam_database_authentication_enabled = var.instance.iam_database_authentication_enabled
  backtrack_window                    = var.instance.backtrack_window
  copy_tags_to_snapshot               = var.instance.copy_tags_to_snapshot
  iam_roles                           = var.instance.iam_roles

}

resource "aws_rds_cluster_instance" "instance" {
  count = var.instance.instance_count

  identifier         = "${var.instance.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.cluster.id
  promotion_tier     = count.index + 1

  engine         = var.instance.engine
  engine_version = var.instance.engine_version
  instance_class = var.instance.instance_size

  db_subnet_group_name = var.subnet

  publicly_accessible = var.instance.public

  auto_minor_version_upgrade   = var.instance.maintenance
  apply_immediately            = var.instance.apply_immediately
  preferred_maintenance_window = var.instance.maintenance_window
}
