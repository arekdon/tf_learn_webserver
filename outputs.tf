output "web_server_id" {
  value = aws_instance.web.id
}

output "web_server_arn" {
  value = aws_instance.web.arn
}

output "web_server_private_ip" {
  value = aws_instance.web.private_ip
}
