terraform {
  backend "s3" {
    key = "stage/data-stores/mysql/terraform.tfstates"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
  required_version = ">= 0.13"
}



provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraformdb"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"

  password = local.mysql-master-password-stage-datastore.password
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage-datastore"
}

locals {
  mysql-master-password-stage-datastore = jsondecode(
    data.aws_secretsmanager_secret_version.db_password.secret_string
  )
}

