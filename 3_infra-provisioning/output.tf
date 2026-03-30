output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web-server-app.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web-server-app.public_ip
}

output "console_Address" {
  description = "Link to Instance on the AWS Console"
  value       = "https://${var.region}.console.aws.amazon.com/ec2/home?region=${var.region}#InstanceDetails:instanceId=${aws_instance.web-server-app.id}"
}
