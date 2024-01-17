terraform {
  required_providers {
    aws = {
      source  = "hashicorp/wrong-aws"
      version = "~> 3.71.0"  # Changed version constraint format
    }
  }
}
provider "aws" {
}

provider "azurerm" {
}
