output "public_ip" {
  value = aws_instance.example.public_ip
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "account_id" {
  value = data.aws_caller_identity.current_caller.account_id
  
}

output "vpc_id" {
  value = module.vpc.vpc_id
}