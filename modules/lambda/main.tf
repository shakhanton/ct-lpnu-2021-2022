locals {
  log_retention = 3
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = var.name
}

module "label_get_all_authors" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-authors"
}

module "label_get_all_courses" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
  name    = "get-all-courses"
}

data "aws_region" "current" {}

module "lambda_function_get_all_authors" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  # function_name                     = "${module.label.id}-get-all-authors"
  function_name                     = module.label_get_all_authors.id
  description                       = "get all authors"
  handler                           = "index.handler"
  runtime                           = "nodejs12.x"
  create_role                       = false
  lambda_role                       = var.get_all_authors_role_arn
  use_existing_cloudwatch_log_group = false
  cloudwatch_logs_retention_in_days = 3

  source_path = "${path.module}/lambda_source/get_all_authors/index.js"

  environment_variables = {
    TABLE_NAME = var.dynamo_db_authors_name
  }

  tags = module.label.tags
}

module "lambda_function_get_all_courses" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.2.0"

  # function_name                     = "${module.label.id}-get-all-courses"
  function_name                     = module.label_get_all_courses.id
  description                       = "get all courses"
  handler                           = "index.handler"
  runtime                           = "nodejs12.x"
  create_role                       = false
  lambda_role                       = var.get_all_courses_role_arn
  use_existing_cloudwatch_log_group = false
  cloudwatch_logs_retention_in_days = 3


  source_path = "${path.module}/lambda_source/get_all_courses/index.js"

  environment_variables = {
    TABLE_NAME = var.dynamo_db_courses_name
  }

  tags = module.label.tags
}

resource "aws_cloudwatch_log_group" "get_all_authors" {
  name              = format("/aws/lambda/%s", module.label_get_all_authors.id)
  retention_in_days = local.log_retention

  # tags = merge(var.tags,
  #   { Function = format("%s", module.label_get_all_authors.id) }
  # )
}

resource "aws_cloudwatch_log_group" "get_all_courses" {
  name              = format("/aws/lambda/%s", module.label_get_all_courses.id)
  retention_in_days = local.log_retention

  # tags = merge(var.tags,
  #   { Function = format("%s", module.label_get_all_courses.id) }
  # )
}