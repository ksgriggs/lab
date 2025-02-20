terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

  default_tags {
    tags = {
      mananged_by = "terraform"
    }
  }
}