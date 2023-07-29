module "security-group" {
  source = "github.com/HelloSleep/t101/4week/t101-4week-challenges//terraform-aws-security-group"
    vpc_id      = "<your_vpc>"
    name       = "your_security_group_name"
    allow_ssh  = true  # Or set it to "false" if you don't want to allow SSH.
    allow_http = true  # Or set it to "false" if you don't want to allow HTTP.
    allow_https = true # Or set it to "false" if you don't want to allow HTTPS.
}
