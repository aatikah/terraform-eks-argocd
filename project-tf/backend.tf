terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }


backend "s3" {
    bucket         = "tikah-backend"
    region         = "us-east-1"
    key            = "argo/terraform.tfstate"
    dynamodb_table = "Lock_State_Files"
    encrypt        = true
  }

}

provider "aws" {
  region  = var.region
}
