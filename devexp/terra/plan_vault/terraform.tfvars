//-----GLOBAL PROJECT VARS------//
project_name    = "api-test-1"
//---------VAULT VARS-----------//
secret_backend  = "amazon02"
secret_role     = "terraformer"
conf_path_vault = "devexp/conf" //Used 4 storing REST address + api_key
//----------AWS VARS------------//
account_id      = "632888177230"     //Used in policy generators
region          = "us-east-2"
artifact_name   = "ssl-test-jenkins-EBS-49.zip"
local_path      = "./devexp/terra/plan_vault"
solution_stack  = "64bit Amazon Linux 2 v3.0.1 running Corretto 11"
api_path        = "beanstalk"   //Used 4 REST control
zone_id         = "Z0909442AOAL213NZWY3"
record_name     = "ebs3.devexp.gq"



