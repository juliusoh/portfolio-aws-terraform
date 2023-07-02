data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "database"
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

module "rds" {
  source = "./tf_aws_rds"
  count  = 1

  backup_retention_period = var.MainRdsBackupRetention
  cidr                    = var.cidr
  db_name                 = var.MainRdsDbSchema
  db_subnets              = module.vpc.public_subnets
  engine                  = "postgres"
  engine_version          = var.MainRdsEngineVersion
  instance_class          = var.MainRdsInstanceClass
  multi_az                = var.MainRdsMultiAZ
  password                = local.db_creds.db_password
  pg_family               = "postgres14"
  port                    = 5432
  skip_final_backup       = var.MainRdsSkipFinalBackup
  stack_name              = var.stack_name
  storage                 = var.MainRdsStorage
  storage_type            = var.MainRdsStorageType
  username                = local.db_creds.db_user
  vpc                     = module.vpc.vpc_id
}
