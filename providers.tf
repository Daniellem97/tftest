terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.71.0"  # Changed version constraint format
    }
  }
}
provider "aws" {
}

required_version = "~> 0.12.29"
}
