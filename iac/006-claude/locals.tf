# Root-level locals for multi-region infrastructure

locals {
  # Primary region naming convention
  name_prefix_primary = "${var.project_name}-primary"

  # Secondary region naming convention
  name_prefix_secondary = "${var.project_name}-secondary"

  # Common tags applied to all resources
  common_tags = merge(
    var.common_tags,
    {
      Terraform = "true"
    }
  )
}
