terraform {
  required_providers {
    aws = {
      version = "~> 6.0.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket       = "hamacher-opentofu-state"
    key          = "aws-segmentation-by-vpc"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Author = "eric"
      Repo   = "aws-segmentation-by-vpc"
      Type   = "opentofu"
    }
  }
}