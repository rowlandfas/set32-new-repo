#creating output for public ip of ec2 instance
output "set32-public-ip" {
  value = aws_instance.set32-instance.public_ip
}

#output for private ip of ec2 instance
output "set32-private-ip" {
  value = aws_instance.set32-instance.private_ip
}

#output for public dns of ec2 instance
output "set32-public-dns" {
  value = aws_instance.set32-instance.public_dns
}

#output the vpc id
output "set32-vpc-id" {
  value = aws_vpc.set32-vpc.id
}