resource "aws_rds_global_cluster" "aurora" {
  provider                  = aws
  global_cluster_identifier = "aurora-global-db"
  engine                    = "aurora-postgresql"
  engine_version            = "13.4"
}

resource "aws_rds_cluster" "primary" {
  provider                  = aws
  global_cluster_identifier = aws_rds_global_cluster.aurora.id
  cluster_identifier        = "aurora-primary-cluster"
  engine                    = "aurora-postgresql"
  engine_version            = "13.4"
  master_username           = "myuser"
  master_password           = "mypassword"
  db_subnet_group_name      = aws_db_subnet_group.primary.name
  vpc_security_group_ids    = [aws_security_group.db.id]
}

resource "aws_rds_cluster" "dr" {
  provider                  = aws.dr
  global_cluster_identifier = aws_rds_global_cluster.aurora.id
  cluster_identifier        = "aurora-dr-cluster"
  engine                    = "aurora-postgresql"
  engine_version            = "13.4"
  master_username           = "myuser"
  master_password           = "mypassword"
  db_subnet_group_name      = aws_db_subnet_group.dr.name
  vpc_security_group_ids    = [aws_security_group.dr_db.id]
}

resource "aws_db_subnet_group" "primary" {
  provider   = aws
  name       = "primary-db-subnet-group"
  subnet_ids = [aws_subnet.primary_private.id]
}

resource "aws_db_subnet_group" "dr" {
  provider   = aws.dr
  name       = "dr-db-subnet-group"
  subnet_ids = [aws_subnet.dr_private.id]
}
