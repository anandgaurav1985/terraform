resource "aws_lb" alb-test {
name = "alb-test"
internal = "false"
load_balancer_type = "application"
subnets = ["subnet-06e2595c", "subnet-7b9ee01d"]

tags = {
  Environment = "production"
  }
}

output alb-dns {
value = "${aws_lb.alb-test.dns_name}"
}
