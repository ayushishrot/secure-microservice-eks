terraform {
  backend "s3" {
    bucket  = "statefile-bucket-devsec" # Name of the S3 bucket for storing Terraform state
    key     = "statefile-bucket-devsec/env:/terraform.tfstate"
    region  = "us-east-1"
    dynamodb_table = "statefile-bucket-lock"
    encrypt = true
  }
}