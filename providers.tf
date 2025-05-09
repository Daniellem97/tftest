terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.71.0"  # This specifies to use a version in the 3.x range, but at least 3.71.0 or newer patch versions
    }
  }
}


provider "aws" {
}
