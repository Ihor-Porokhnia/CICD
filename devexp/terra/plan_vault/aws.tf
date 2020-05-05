terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.aws_secret.access_key
  secret_key = data.vault_aws_access_credentials.aws_secret.secret_key
  token      = data.vault_aws_access_credentials.aws_secret.security_token
  region     = var.region
}

resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "backends3bucket06"
  acl    = "private"
  region = var.region  
}

resource "aws_s3_bucket_object" "artifact" {
  key        = "artifacts01/ssl-test-jenkins-EBS-48.zip"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "ssl-test-jenkins-EBS-48.zip"  
}

resource "aws_elastic_beanstalk_application" "beanapp" {
  name        = "app-ver3"
  description = "test application 4 terraform"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tf-test-version-label"
  application = aws_elastic_beanstalk_application.beanapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.backend_S3_bucket.id
  key         = aws_s3_bucket_object.artifact.id
}


resource "aws_iam_instance_profile" "beanstalk_service" {
    name = "beanstalk-service-user"
    role = aws_iam_role.beanstalk_service.name
}

resource "aws_iam_instance_profile" "beanstalk_ec2" {
    name = "beanstalk-ec2-user"
    role = aws_iam_role.beanstalk_ec2.name
}

resource "aws_iam_role" "beanstalk_service" {
    name = "beanstalk-service-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF

}

resource "aws_iam_role" "beanstalk_ec2" {
    name = "beanstalk-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "beanstalk_service" {
    name = "elastic-beanstalk-service"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_policy_attachment" "beanstalk_service_health" {
    name = "elastic-beanstalk-service-health"
    roles = ["${aws_iam_role.beanstalk_service.id}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_worker" {
    name = "elastic-beanstalk-ec2-worker"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_web" {
    name = "elastic-beanstalk-ec2-web"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_container" {
    name = "elastic-beanstalk-ec2-container"
    roles = ["${aws_iam_role.beanstalk_ec2.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}



resource "aws_elastic_beanstalk_environment" "api" {
    name = "api-test"
    application = aws_elastic_beanstalk_application.beanapp.name
    solution_stack_name = "64bit Amazon Linux 2 v3.0.0 running Corretto 11"
    wait_for_ready_timeout = "20m"
  
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "InstanceType"
        value     = "t2.micro"
    } 
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "ServiceRole"
        value     = aws_iam_instance_profile.beanstalk_service.name
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     = aws_iam_instance_profile.beanstalk_ec2.name
    }

}

variable "region" {
  type    = string  
}
