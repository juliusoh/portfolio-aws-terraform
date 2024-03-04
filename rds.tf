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


resource "aws_security_group" "aurora_sg" {
  name        = "aurora-serverless-sg"
  description = "Allow all inbound traffic for Aurora Serverless"
  vpc_id      = module.vpc.vpc_id 
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  master_username         = "admin"
  master_password         = local.db_creds.db_pgcs # Use a secure password
  db_subnet_group_name    = aws_db_subnet_group.aurora_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql5_7_cluster_parameter_group.name
}

resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = module.vpc.public_subnets # Replace with your subnet IDs
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2 # Number of instances to create
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.r5.large" # Change to your desired instance class
  engine             = "aurora-mysql"
  engine_version     = "5.7.mysql_aurora.2.11.2"
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql5_7_cluster_parameter_group" {
  name        = "aurora-mysql5-7-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "Aurora MySQL 5.7 cluster parameter group"

  parameter {
    name         = "time_zone"
    value        = "UTC"
    apply_method = "immediate"
  }

  # Add other parameters here
}