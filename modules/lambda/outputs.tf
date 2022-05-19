output "cw_log_group_get_all_authors_arn" {
  value = aws_cloudwatch_log_group.get_all_authors.arn
}

output "cw_log_group_get_all_courses_arn" {
  value = aws_cloudwatch_log_group.get_all_courses.arn
}

output "get_all_courses_lambda_function_name" {
  value = module.lambda_function_get_all_courses.lambda_function_name
}
