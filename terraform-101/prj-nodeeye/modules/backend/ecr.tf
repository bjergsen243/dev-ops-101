resource "aws_ecr_repository" "application" {
  name                 = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-application"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "application-migration" {
  name                 = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-application-migration"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "lambda" {
  name                 = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-lambda"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
