/*
This plan generates python lambda from template, zips it into archive and uploads it
*/
resource "aws_lambda_function" "lambda_back" {
  filename         = "${var.func_path}/function_b.zip"
  function_name    = "${var.project_name}-lambda-beanstalk-control"
  role             = aws_iam_role.lambda_back_role.arn
  handler          = "function_b.lambda_handler"  
  runtime          = "python3.8"
  timeout          = "10"
  depends_on = [
    data.archive_file.lambda_back_zip,
  ]
}
resource "aws_lambda_function" "lambda_front" {
  filename         = "${var.func_path}/function_f.zip"
  function_name    = "${var.project_name}-lambda-s3site-control"
  role             = aws_iam_role.lambda_front_role.arn
  handler          = "function_f.lambda_handler"  
  runtime          = "python3.8"
  timeout          = "10"
  depends_on = [
    data.archive_file.lambda_front_zip,
  ]
}


resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_back.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

data "template_file" "function_back" {
  template = file("${var.func_path}/function_b.py.tpl")
  vars = {
    APPNAME   = aws_elastic_beanstalk_application.beanapp.name
    ENVID     = aws_elastic_beanstalk_environment.api.id
    S3BUCKET  = aws_s3_bucket.static_website.bucket
    S3PREFIX  = "${var.upload_s3_prefix}/"
    S3PREFIXB = "${var.back_s3_prefix}/"
    S3PREFIXF = "${var.front_s3_prefix}/"
  }
}

data "template_file" "function_front" {
  template = file("${var.func_path}/function_f.py.tpl")
  vars = {
    APPNAME   = aws_elastic_beanstalk_application.beanapp.name
    ENVID     = aws_elastic_beanstalk_environment.api.id
    S3BUCKET  = aws_s3_bucket.static_website.bucket
    S3PREFIX  = "${var.upload_s3_prefix}/"
    S3PREFIXB = "${var.back_s3_prefix}/"
    S3PREFIXF = "${var.front_s3_prefix}/"
  }
}

data "archive_file" "lambda_back_zip" {
  type = "zip"
  source {
    content  = data.template_file.function_back.rendered
    filename = "function_b.py"
  }
  output_path = "${var.func_path}/function_b.zip"
}
data "archive_file" "lambda_front_zip" {
  type = "zip"
  source {
    content  = data.template_file.function_front.rendered
    filename = "function_f.py"
  }
  output_path = "${var.func_path}/function_f.zip"
}

