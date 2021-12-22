terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }

  backend "s3" {
    bucket = "netology-s3"
    key    = "main/netology"
    region = "eu-central-1"
  }
}
