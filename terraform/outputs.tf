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
