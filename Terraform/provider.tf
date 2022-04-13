# Variable
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
    default = "us-east-1"
}

terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.14.0"
    }
  }
}

provider "postgresql" {
  scheme          = "awspostgres"
  host            = "database-1.chzufnipo7hy.us-east-1.rds.amazonaws.com"
  port            = 5432
  database        = "database-1"
  username        = "postgres"
  password        = "postgres"
  sslmode         = "require"
  
}


# Provider
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = "us-east-1"
}


