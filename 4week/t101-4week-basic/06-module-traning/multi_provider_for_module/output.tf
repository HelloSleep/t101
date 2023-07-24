# output.tf
output "module_output_singapore" {
  value = module.ec2_singapore.private_ip
}

output "module_output_seoul" {
  value = module.ec2_seoul.private_ip
}