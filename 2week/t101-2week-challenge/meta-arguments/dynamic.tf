variable "allowed_ports" {
  description = "List of ports to allow in the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group for dynamic block demonstration"

  dynamic "ingress" {
    for_each = var.allowed_ports
    # iterator = each
    content {
      from_port   = each.value
      to_port     = each.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "example-dynamic"
  }
}
