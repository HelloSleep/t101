locals {
  name = "mytest"
}

resource "aws_iam_user" "myiamuser1" {
  name = "${local.name}1"
}