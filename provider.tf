terraform {
  backend "s3" {
    bucket = "hytssk-remote-tfstate"
    region = "ap-northeast-1"
    key    = "resources/kms/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
