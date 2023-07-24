# variable "sensitive_content" {
#   default   = "secret"
#   #sensitive = true
# }

# resource "local_file" "foo" {
#   content  = upper(var.sensitive_content)
#   filename = "${path.module}/foo.bar"

#   provisioner "local-exec" {
#     command = "echo The content is ${self.content}"
#   }

#   provisioner "local-exec" {
#     command    = "abc"
#     on_failure = continue
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = "echo The deleting filename is ${self.filename}"
#   }
# }

resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}