output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "s3_bucket_name" {
  description = "Website S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "website_url" {
  description = "Website URL"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "ecr_repository_url" {
  description = "ECR repository"
  value       = aws_ecr_repository.app.repository_url
}
