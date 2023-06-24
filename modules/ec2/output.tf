output "web_server_instance_id" {
    value = aws_instance.web_server.id
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

# output "bastion_host" {
#     value = aws_instance.bastion_host.id
# }

# output "bastion_host_public_ip" {
#   value = aws_instance.bastion_host.public_ip
# }
