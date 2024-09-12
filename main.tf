terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

resource "random_string" "s3_id" {
  length  = 6
  special = false
  upper   = false
}

provider "aws" {
  profile = "master-tfstate-admin"
}

#create s3 bucket
resource "aws_s3_bucket" "master-tfstate" {
  bucket = "master-tfstate-${random_string.s3_id.result}"
}

resource "aws_s3_bucket_versioning" "master-tfstate-versioning" {
  bucket = aws_s3_bucket.master-tfstate.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

#create dynamodb table for state locking
resource "aws_dynamodb_table" "master-tfstate-lock" {
  name         = "master-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # LockID is the primary key cannot change
  attribute {
    name = "LockID"
    type = "S"
  }
}

#create local to test

resource "random_string" "suffix" {
  length  = 16
  special = true
}

locals {
  pod_id = lower("${var.pod_name}-${random_string.suffix.result}")
}





