resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function_get_all_authors.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.aws_lambda_permission_api_gateway_source_arn}/*${var.aws_api_gateway_resource_authors_path}"
}


