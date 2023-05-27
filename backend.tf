terraform {
  backend "s3" {
    bucket = "tfstate-personal"
    key    = "terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "tfstate-personal"
  }
}
