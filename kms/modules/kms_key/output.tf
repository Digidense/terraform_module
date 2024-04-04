output "key_id" {
  description = "The ID of the created KMS key."
  value       = aws_kms_key.my_kms_key.id
}

output "arn" {
  description = "The ARN of the created KMS key."
  value       = aws_kms_key.my_kms_key.id
}