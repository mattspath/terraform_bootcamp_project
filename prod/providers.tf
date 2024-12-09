terraform {
  backend "s3" {
    bucket  = "mattspath-tf-state"
    key     = "terraform_bootcamp_project/prod/terraform.tfstate"
    region  = "us-west-2"
    profile = "terraform_bootcamp"
  }



  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
  required_version = "~> 1.9.8"
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "terraform_bootcamp"
}


