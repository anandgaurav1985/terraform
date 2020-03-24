variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "RDS_PASSWORD" {}

variable "AWS_REGION" {
default = "eu-west-1"
} 


variable "AMIS" {
type = map
default = {
eu-west-1 = "ami-099a8245f5daa82bf"
eu-west-2 = "ami-099a8245f5daa82bf"
   }
}

variable "PATH_TO_PUBLIC_KEY" {
 default = "mykey.pub"
 }

variable "PATH_TO_PRIVATE_KEY" {
 default = "mykey"
 }

variable "INSTANCE_USERNAME" {
 default = "ec2-user"
 }
