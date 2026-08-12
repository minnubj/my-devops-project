resource "aws_ecr_repository" "app" {
  name                 = "my-devops-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = "my-devops-app"
    ManagedBy = "Terraform"
  }
}
