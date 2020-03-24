resource "aws_key_pair" "mykey" {
 key_name = "mykey"
 public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}


resource "aws_instance" appserver2 {
 ami = "${lookup(var.AMIS, var.AWS_REGION)}"
 instance_type = "t2.micro"
 key_name = "${aws_key_pair.mykey.key_name}"
#private_ip ="10.0.1.4"
# security_groups = [ "from_ireland","default" ]
#public vpc subnet
 subnet_id = "${aws_subnet.main-public-1.id}"
#role
 iam_instance_profile = "${aws_iam_instance_profile.s3-mybucket-role-instanceprofile.name}"

#vpc security group id's
 vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

/*
#increase boot (root) volume size as default is 8 GB
root_block_device {
volume_size = "16"
volume_type = "gp2"
delete_on_termination = "true"
}
*/

 provisioner "file" {
 source = "run.sh"
 destination = "/tmp/run.sh"
 }
 
 provisioner "remote-exec" {
  inline = [ 
   "chmod +x /tmp/run.sh",
   "sudo /tmp/run.sh"
   ]

 }

 connection {
 type = "ssh"
 user =	"${var.INSTANCE_USERNAME}"
 private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
 host = "${self.public_ip}"
 }

#user data
 user_data = "!/bin/bash\nsudo yum update -y\n"
# user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"
}
#instance block ends

#elastic ip
resource aws_eip "appserver2-eip" {
instance = "${aws_instance.appserver2.id}"
vpc = "true"
}

output appserver2eip {
value = "{$aws_eip.appserver2-eip.public_ip}"
}


/*
output "ip" {
value = "${aws_instance.appserver2.public_ip}"
}
*/
/*
provisioner "local-exec" {
command = "echo ${aws_instance.appserver2.private_ip} >> private_ip.txt"
}
*/

data "aws_ip_ranges" "ireland_ec2" {
 regions = ["eu-west-1"]
 services = ["ec2"]
}

resource "aws_security_group" "from_ireland" {
 name = "from_ireland"
 ingress { 
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
  cidr_blocks = "${data.aws_ip_ranges.ireland_ec2.cidr_blocks}"

  }
}

resource "aws_security_group" "allow-ssh" {
 name = "allow-ssh"
 vpc_id = "${aws_vpc.main.id}"
 ingress {
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  }
 tags = {
 name = "allow-ssh"
 }
}

resource "aws_ebs_volume" "ebs-volume-1" {
availability_zone = "eu-west-1a"
size = "20"
type = "gp2"
tags = {
name = "extra volume data"
 }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
device_name = "/dev/xvdb"
volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
instance_id = "${aws_instance.appserver2.id}"
}

resource "aws_route53_zone" "example-com" {
name = "abc.com"
}

resource "aws_route53_record" "server1-record" {
zone_id = "${aws_route53_zone.example-com.zone_id}"
name = "server1.example.com"
type = "A"
ttl = "200"
records = ["${aws_eip.appserver2-eip.public_ip}"]
}

#name server for your domain to register dns with third party
output "nameserver" {
value = "${aws_route53_zone.example-com.name_servers}"
}

#s3 bucket
resource "aws_s3_bucket" "mybucket-anand" {
bucket = "mybucket-anand"
acl = "private"

tags = {
name = "mybucket-anand"
}
}
