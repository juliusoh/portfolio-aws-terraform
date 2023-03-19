module "rds" {
  source = "./tf_aws_rds"
  count  = 1

  backup_retention_period = var.MainRdsBackupRetention
  cidr                    = var.cidr
  db_name                 = var.MainRdsDbSchema
  db_subnets              = module.vpc.private_subnets
  engine                  = "postgres"
  engine_version          = var.MainRdsEngineVersion
  instance_class          = var.MainRdsInstanceClass
  multi_az                = var.MainRdsMultiAZ
  password                = var.MainRdsPassword
  pg_family               = "postgres13"
  port                    = 5432
  skip_final_backup       = var.MainRdsSkipFinalBackup
  stack_name              = var.stack_name
  storage                 = var.MainRdsStorage
  storage_type            = var.MainRdsStorageType
  username                = var.MainRdsUser
  vpc                     = module.vpc.vpc_id
}
