terraform {
  backend "s3" {
    bucket         = "master-tfstate-dkztcv"
    key            = "terraform.tfstate"
    dynamodb_table = "master-tfstate-lock"
    region         = "ap-southeast-1"
    profile        = "master-tfstate-admin"
  }
}
