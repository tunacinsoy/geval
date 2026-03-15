provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "SecureHRDocs"
      Environment = var.environment
      Owner       = var.owner
    }
  }
}

provider "aws" {
  alias  = "replica"
  region = var.replication_region
  default_tags {
    tags = {
      Project     = "SecureHRDocs"
      Environment = var.environment
      Owner       = var.owner
    }
  }
}
