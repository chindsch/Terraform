# Configure the AWS Provider
provider "aws" {
  version    = "~> 3.0"
  access_key = AWS_ACCESS_KEY
  secret_key = AWS_SECRET_KEY
  region     = "us-east-1"
}

/*
resource "aws_s3_bucket" "website_bucket" {
  bucket = "blog-media-bucketchc"
  acl    = "private"

  tags = {
    Name        = "blog bucket"
    Environment = "Dev"
  }
}

*/ //Create s3 bucket with static website enabled
resource "aws_s3_bucket" "website_bucket" {
  bucket = "blog-media-bucketchc"
  acl    = "public-read"
  policy = file("policy.json")

  tags = {
    Name        = "blog bucket"
    Environment = "Dev"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = jsonencode(
      [{
        "Condition" : {
          "KeyPrefixEquals" : "docs/"
        },
        "Redirect" : {
          "ReplaceKeyPrefixWith" : "documents/"
        }
    }])
  }
}

//Create an EC2 instance for development
resource "aws_instance" "dev_server" {
  count = 2
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t2.micro"

  tags = {
    Name = "internal-dev"
  }
}