output "instance_ip_addr" {
  value       = aws_instance.nginx.public_ip
  description = "Public IP of the NGINX instance"
}

output "instance_dns_addr" {
  value       = aws_instance.nginx.public_dns
  description = "Public DNS of the NGINX instance"
}
