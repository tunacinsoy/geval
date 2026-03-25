variable "transit_gateway_route_table_id" {
  description = "Transit Gateway route table that handles resolver traffic"
  type        = string
}

variable "transit_gateway_attachment_id" {
  description = "Existing Transit Gateway attachment ID"
  type        = string
}

variable "destination_cidr_block" {
  description = "CIDR block to route through the attachment"
  type        = string
}

variable "tags" {
  description = "Tags to propagate"
  type        = map(string)
  default     = {}
}
