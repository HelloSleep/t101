variable "enable_security" {
  description = "Enable the security module."
  default     = true
}

resource "aws_security_group" "sg" {
  count       = var.enable_security ? 1 : 0
  name        = "security_group"
  description = "Managed by Terraform"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

output "sg_id" {
  value = var.enable_security ? aws_security_group.sg[0].id : "Security module is not enabled."
}
