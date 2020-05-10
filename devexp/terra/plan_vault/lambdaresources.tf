resource "aws_lambda_function" "test_lambda" {
  filename         = "function.zip"
  function_name    = "${var.project_name}-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_handler"
  source_code_hash = filebase64sha256("function.zip")
  runtime          = "python3.8"
  depends_on = [
    archive_file.lambda_zip,
  ]
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
  output_path = "function.zip"
}
