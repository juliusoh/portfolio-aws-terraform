output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_user" {
  value = aws_db_instance.main.username
}

output "rds_db_schema" {
  value = aws_db_instance.main.name
}

output "rds_db_engine" {
  value = aws_db_instance.main.engine
}
