#AWS account ID
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

#AWS user ID
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

#AWS регион, который используется в данный момент
output "region_name" {
  value = data.aws_region.current.name
}

#Приватный IP ec2 инстанса
output "instance_ip_addr" {
  value = aws_instance.netology.private_ip
}

output "instance_subnet" {
  value = aws_instance.netology.subnet_id
}

/*output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
*/
