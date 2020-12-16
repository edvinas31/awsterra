terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.21.0"
    }   
  }
  required_version = ">= 0.13"
  backend "s3" {
      key = "workspaces-example/terraform.tfstate"
  }
}

resource "aws_instance" "example" {
  ami = "ami-0cdae9530d06806d4"
  instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
}