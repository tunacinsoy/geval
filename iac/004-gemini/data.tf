
resource "aws_db_instance" "main" {
  allocated_storage    = var.db_allocated_storage
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
}
