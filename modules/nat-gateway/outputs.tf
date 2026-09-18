output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways."
  value       = aws_nat_gateway.this[*].id
}

output "nat_eip_public_ips" {
  description = "Public IPs of the NAT Elastic IPs."
  value       = aws_eip.nat[*].public_ip
}