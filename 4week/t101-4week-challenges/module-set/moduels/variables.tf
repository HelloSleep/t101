variable "name" {
  description = "The name of the security group"
  type        = string
}

variable "vpc_id"{
  description = "The id of vpc"
  type        = string
}

variable "allow_ssh" {
  description = "Allow inbound SSH traffic true or false"
  type        = bool
  
}

variable "allow_http" {
  description = "Allow inbound HTTP traffic true or false"
  type        = bool
  
}

variable "allow_https" {
  description = "Allow inbound HTTPS traffic true or false"
  type        = bool
  
}