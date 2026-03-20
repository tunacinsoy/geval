resource "aws_vpc_endpoint" "s3_primary" {
  vpc_id            = aws_vpc.primary.id
  service_name      = "com.amazonaws.${var.primary_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.primary_public.id, aws_route_table.primary_private.id]
}

resource "aws_vpc_endpoint" "dynamodb_primary" {
  vpc_id            = aws_vpc.primary.id
  service_name      = "com.amazonaws.${var.primary_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.primary_public.id, aws_route_table.primary_private.id]
}

resource "aws_vpc_endpoint" "s3_dr" {
  provider          = aws.dr
  vpc_id            = aws_vpc.dr.id
  service_name      = "com.amazonaws.${var.dr_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.dr_public.id, aws_route_table.dr_private.id]
}

resource "aws_vpc_endpoint" "dynamodb_dr" {
  provider          = aws.dr
  vpc_id            = aws_vpc.dr.id
  service_name      = "com.amazonaws.${var.dr_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.dr_public.id, aws_route_table.dr_private.id]
}
