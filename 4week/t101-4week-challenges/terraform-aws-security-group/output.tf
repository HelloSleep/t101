output "secruity_names" {
  value = {
    ssh : var.allow_ssh,
    http : var.allow_http,
    https : var.allow_https
  }
}