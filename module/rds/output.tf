output "db_endpoint" {
  value = aws_db_instance.reader_rds.endpoint
  description = "The endpoint of the RDS instance"
}