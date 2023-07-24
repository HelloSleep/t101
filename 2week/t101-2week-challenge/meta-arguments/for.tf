variable "names" {
  default = ["a","b","c","d","e","z"]
}

locals {
  allowed_letters = ["a", "b", "c", "d", "e"]
}

resource "local_file" "abc" {
  content = jsonencode([for letter in var.names: letter if can(index(local.allowed_letters, letter))])

  filename = "${path.module}/abc.txt"
}
