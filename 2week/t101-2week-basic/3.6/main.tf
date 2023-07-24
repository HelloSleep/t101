# variable "my_password" {}

# resource "local_file" "abc" {
#   content  = var.my_password
#   filename = "${path.module}/abc.txt"
# }


# 민감변수
# variable "my_password" {
#   default   = "password"
#   sensitive = true
# }

# resource "local_file" "abc" {
#   content  = var.my_password
#   filename = "${path.module}/abc.txt"
# }


variable "my_var" {}

resource "local_file" "abc" {
  content  = var.my_var
  filename = "${path.module}/abc.txt"
}