//-----GLOBAL PROJECT VARS------//
project_name    = "api-test-1"
//---------VAULT VARS-----------//
secret_backend  = "amazon02"
secret_role     = "terraformer"
conf_path_vault = "devexp/conf" //Used 4 storing REST address + api_key
//----------AWS VARS------------//
account_id      = "632888177230"     //Used in policy generators
region          = "eu-central-1"
artifact_name   = "ssl-test-jenkins-EBS-48.zip"
local_path      = "./target"
func_path       = "./cicd/devexp/terra/create_infrastructure"
upload_s3_prefix= "upload"
front_s3_prefix = "frontend"
back_s3_prefix  = "backend"
solution_stack  = "64bit Amazon Linux 2 v3.0.1 running Corretto 11"
api_1_path      = "beanstalk"   //Used 4 REST control
zone_id         = "Z0909442AOAL213NZWY3"
record_name     = "ebs1.devexp.gq"
ssl_cert_arn    = "arn:aws:acm:eu-central-1:632888177230:certificate/1284ead2-1ec6-4834-9da5-139d4f364bd2"
ssl2_cert_arn   = "arn:aws:acm:us-east-1:632888177230:certificate/7748a391-158d-4fc6-ad8d-90c22a4372a9"
domain_name     = "devexp.gq"
redirect_domain = "devexp.gq"
public_dir      = "public"





