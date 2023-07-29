module security-group{
    source = "../moduels"
    vpc_id      = "vpc-0cea1bd4e3203a40c"
    name       = "your_security_group_name"
    allow_ssh  = true  # Or set it to "false" if you don't want to allow SSH.
    allow_http = true  # Or set it to "false" if you don't want to allow HTTP.
    allow_https = true # Or set it to "false" if you don't want to allow HTTPS.
    
}
