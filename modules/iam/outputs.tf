output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile for the app tier."
  value       = aws_iam_instance_profile.app.arn
}