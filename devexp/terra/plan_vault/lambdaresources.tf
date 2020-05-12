/*
This plan generates python lambda from template, zips it into archive and uploads it
*/
resource "aws_lambda_function" "lambda" {
  filename         = "${var.local_path}/function.zip"
  function_name    = "${var.project_name}-lambda-beanstalk-control"
  role             = aws_iam_role.lambda_role.arn
  handler          = "function.lambda_handler"
  //source_code_hash = filebase64sha256("${var.local_path}/function.zip")
  runtime          = "python3.8"
  depends_on = [
    data.archive_file.lambda_zip,
  ]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

data "template_file" "function" {
  template = file("${var.local_path}/function.py.tpl")
  vars = {
    APPNAME = aws_elastic_beanstalk_application.beanapp.name
    ENVID   = aws_elastic_beanstalk_environment.api.id
  }
}

data "archive_file" "lambda_zip" {
  type = "zip"
  source {
    content  = data.template_file.function.rendered
    filename = "function.py"
  }
  output_path = "${var.local_path}/function.zip"
}

data "aws_lambda_invocation" "update_ver_invoke" {
  function_name = aws_lambda_function.lambda.function_name
  //input =  "{ \"app_version\": \"api-test-1-ssl-test-jenkins-EBS-48.zip\" }"
  depends_on = [aws_lambda_function.lambda]
}

      

resource "null_resource" "null" {
  
  triggers = {
    invoke = data.aws_lambda_invocation.update_ver_invoke
    input = "{asddsa}"
  }
}
