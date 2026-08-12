variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Jenkins EC2 instance type"
  type        = string
  default     = "t3.small"

  validation {
    condition = contains([
      "t3.micro",
      "t3.small",
      "t3.medium"
    ], var.instance_type)

    error_message = "Allowed values: t3.micro, t3.small, t3.medium."
  }
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}
