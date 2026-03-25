resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ssm"
  subnet_ids   = values(aws_subnet.private)[*].id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.builder.id]
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ssmmessages"
  subnet_ids = values(aws_subnet.private)[*].id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.builder.id]
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private.id, aws_route_table.public.id]
}

resource "aws_vpc_endpoint" "secrets" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.secretsmanager"
  subnet_ids = values(aws_subnet.private)[*].id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [aws_security_group.builder.id]
}
