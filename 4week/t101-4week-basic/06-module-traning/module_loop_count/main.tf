# provider "aws" {
#   region = "ap-northeast-2"  
# }

# module "ec2_seoul" {
#   count  = 2
#   source = "../modules/terraform-aws-ec2"
#   instance_type = "t3.small"
# }

# output "module_output" {
#   value  = module.ec2_seoul[*].private_ip   
# }

# 위의 count문을 for_each 문으로 구현
locals {
  env = {
    dev = {
      type = "t3.micro"
      name = "dev_ec2"
    }
    prod = {
      type = "t3.medium"
      name = "prod_ec2"
    }
  }
}

module "ec2_seoul" {
  for_each = local.env
  source = "../modules/terraform-aws-ec2"
  instance_type = each.value.type
  instance_name = each.value.name
}

output "module_output" {
  value  = [
    for k in module.ec2_seoul: k.private_ip
  ]
}