terraform {
  backend "s3" {
      key = "global/s3/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
  version = "~> 3.20.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "testterrastate-3113"

  # Prevent accidental prevention of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  #Enable versioning so we can see the full revision history of our 
  #state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "testterra_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
      name = "LockID"
      type = "S"
  }
}




