# terraform_rds_cluster

Terraform module to create rds cluster. This module is used for instances with cluster support. If you want to create a simple single instance of RDS DB, please have a look at <https://https://github.com/virsas/terraform_rds_instance>

## Dependencies

- Paramteres - <https://github.com/virsas/terraform_rds_cluster_parameters>
- Subnets - <https://github.com/virsas/terraform_rds_subnet>
- Security groups - <https://github.com/virsas/terraform_vpc_sg>

## Terraform example

``` terraform
###################
# RDS variable
###################
variable "rds_cluster" {
  default = {
    # number of instaces in the cluster (one RW and rest RO and ready for failover)
    instance_count = 2
    name = "rds_cluster"
    # engine must be one that supports RDS cluster
    engine = "aurora-mysql"
    engine_mode = "provisioned"
    engine_version = "5.7.mysql_aurora.2.08.0"
    password = "dbpassword"
    username = "dbname"
    port = "3306"
    final_snapshot_identifier = "final"
    skip_final_snapshot = false
    deletion_protection = true
    backup_period = "7"
    backup_window = "02:01-03:00"
    maintenance_window = "sun:03:01-sun:04:00"
    snapshot_identifier = ""
    apply_immediately = false
    iam_database_authentication_enabled = false
    backtrack_window = 0
    copy_tags_to_snapshot = true
    iam_roles = []
    instance_size = "db.t3.small"
    public = true
    maintenance = true
    encrypted = true
  }
}

###################
# RDS module
###################
module "rds_cluster" {
  source            = "git::https://github.com/virsas/terraform_rds_cluster.git?ref=v1.0.0"
  instance          = var.rds_cluster
  security_groups   = [ module.vpc_sg_admin.id, module.vpc_sg_sql.id ]
  params            = module.rds_example_cluster_params.id
  subnet            = module.rds_exmaple_subnet.id
}
```
