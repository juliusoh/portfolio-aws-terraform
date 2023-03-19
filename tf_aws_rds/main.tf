resource "aws_db_instance" "main" {
  identifier                 = "tf-${var.stack_name}-postgres"
  allocated_storage          = var.storage
  auto_minor_version_upgrade = false
  backup_retention_period    = var.backup_retention_period
  backup_window              = "10:00-11:00"
  copy_tags_to_snapshot      = true
  db_subnet_group_name       = aws_db_subnet_group.main.id
  engine                     = var.engine
  engine_version             = var.engine_version
  final_snapshot_identifier  = "${var.stack_name}-backup"
  instance_class             = var.instance_class
  maintenance_window         = "sun:03:30-sun:04:30"
  multi_az                   = var.multi_az
  name                       = var.db_name
  parameter_group_name       = "default.postgres13"
  password                   = var.password
  port                       = var.port
  skip_final_snapshot        = var.skip_final_backup
  storage_type               = var.storage_type
  username                   = var.username
  vpc_security_group_ids     = [aws_security_group.db.id]

  tags = {
    Name = "${var.stack_name}-main-rds"
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "tf-${var.stack_name}-main"
  description = "Our main group of subnets for RDS"
  subnet_ids  = var.db_subnets
  tags = {
    Name = "${var.stack_name}-main-subnet-group"
  }
}
