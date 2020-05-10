resource "aws_lambda_function" "test_lambda" {
  filename         = "${var.local_path}/function.zip"
  function_name    = "${var.project_name}-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "function.lambda_handler"
  source_code_hash = filebase64sha256("${var.local_path}/function.zip")
  runtime          = "python3.8"
  depends_on = [
    data.archive_file.lambda_zip,
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
  output_path = "${var.local_path}/function.zip"
}
