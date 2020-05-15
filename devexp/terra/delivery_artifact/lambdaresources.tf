/*
This plan generates python lambda from template, zips it into archive and uploads it
*/

 data "aws_lambda_invocation" "create_version" {
   provisioner "local-exec" {
    command = "sleep 10"
  }
  function_name = "${var.project_name}-lambda-beanstalk-control"
  input = jsonencode({
  "operation"="create"  
  "app_version"=var.artifact_name 
   })
  depends_on = [aws_s3_bucket_object.artifact]
}

data "aws_lambda_invocation" "set_version" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
  function_name = "${var.project_name}-lambda-beanstalk-control"
  input = jsonencode({
  "operation"="set"  
  "app_version"=var.artifact_name 
   })
  depends_on = [aws_s3_bucket_object.artifact, data.aws_lambda_invocation.set_version]
}
output "lambda_create_output" {
  value = jsondecode(data.aws_lambda_invocation.create_version.result)["params"]
} 
output "lambda_set_output" {
  value = jsondecode(data.aws_lambda_invocation.set_version.result)["params"]
} 