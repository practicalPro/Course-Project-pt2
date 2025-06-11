output "private_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the generated private key"
}

output "public_ip" {
  description = "Public IP of the Minecraft server"
  value       = aws_instance.minecraft_server.public_ip
}


output "instance_id" {
  value = aws_instance.minecraft_server.id
  description = "The ID of the Minecraft EC2 instance"
}
