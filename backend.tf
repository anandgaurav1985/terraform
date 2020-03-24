terraform {
 backend "s3" {
  bucket = "mybucket-practice"
  key = "terraform.tfstate"
  region = "eu-west-1"
 }
}
