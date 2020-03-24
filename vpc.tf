#VPC
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 instance_tenancy = "default"
 enable_dns_hostnames = "true"
 tags = {
  name = "main"
  }
 }

#Subnet
resource "aws_subnet" "main-public-1" {
 vpc_id = "${aws_vpc.main.id}"
 cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "eu-west-1a"
 tags = {
  name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
 vpc_id = "${aws_vpc.main.id}"
 cidr_block = "10.0.2.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "eu-west-1b"
 tags = {
  name = "main-public-2"
  }
}

resource "aws_subnet" "main-private-1" {
 vpc_id = "${aws_vpc.main.id}"
 cidr_block = "10.0.3.0/24"
 map_public_ip_on_launch = "false"
 availability_zone = "eu-west-1a"
 tags = {
  name = "main-private-1"
   }
}

resource "aws_subnet" "main-private-2" {
 vpc_id = "${aws_vpc.main.id}"
 cidr_block = "10.0.4.0/24"
 map_public_ip_on_launch = "false"
 availability_zone = "eu-west-1b"
 tags = {
  name = "main-private-2"
   }
 }

#Internet GW
resource "aws_internet_gateway" "main-gw" {
 vpc_id = "${aws_vpc.main.id}"
 tags = {
  name = "main"
  }
 }

#Route Table
resource "aws_route_table" "main-public" {
 vpc_id = "${aws_vpc.main.id}"
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main-gw.id}"
  }
 tags = {
  name = "main-public-1"
  } 
}

#Route Table Association - Public
resource "aws_route_table_association" "main-public-1-a" {
 subnet_id = "${aws_subnet.main-public-1.id}"
 route_table_id = "${aws_route_table.main-public.id}"
 }

resource "aws_route_table_association" "main-public-2-a" {
 subnet_id = "${aws_subnet.main-public-2.id}"
 route_table_id = "${aws_route_table.main-public.id}"
 }



 
