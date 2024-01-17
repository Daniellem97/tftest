terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
       version = "3.87.0"
    }
  }
}

provider "aws" {
}

provider "azurerm" {
}
