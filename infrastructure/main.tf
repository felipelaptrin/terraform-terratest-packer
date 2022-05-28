terraform {
  required_version = "~> 1.2.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }

  backend "s3" {
    bucket = "terraform-states-flat"
    key    = "states/terraform-terratest/states.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Name  = "Flugel"
      Owner = "InfraTeam"
    }
  }
}
