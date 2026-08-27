output "security_group_id" {
  description = "ID du Security Group créé"
  value       = aws_security_group.this.id
}


output "sg_name" {
  value = aws_security_group.this.name
}
output "sg_arn" {
  value = aws_security_group.this.arn
}
