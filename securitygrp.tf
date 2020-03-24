resource "aws_security_group" "allow-mariadb" {
vpc_id = "${aws_vpc.main.id}"
name = "allow-mariadb"
ingress {
from_port = 3306
to_port = 3306
protocol = "tcp"
security_groups = ["${aws_security_group.allow-ssh.id}"] #allow access from instance
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
self = true
}
tags = {
name = "allow-mariadb"
}
}
