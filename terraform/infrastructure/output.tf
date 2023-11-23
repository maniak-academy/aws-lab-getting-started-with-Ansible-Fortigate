
output "FGTPublicIP" {
  value = aws_eip.FGTPublicIP.public_ip
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = aws_instance.fgtvm.id
}

output "LoadBalancerPrivateIP" {
  value = data.aws_network_interface.vpcendpointip.private_ip
}

output "CustomerVPC" {
  value = aws_vpc.customer-vpc.id
}

output "FGTVPC" {
  value = aws_vpc.fgtvm-vpc.id
}

output "customer_vpc_id" {
  value = aws_vpc.customer-vpc.id
}
output "fwsshkey" {
  value = aws_key_pair.fwsshkey.key_name
}

output "csprivatesubnetaz1" {
  value = aws_subnet.csprivatesubnetaz1.id
}
output "csprivatesubnetaz2" {
  value = aws_subnet.csprivatesubnetaz2.id
}
