variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}
