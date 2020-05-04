terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_generic_secret.aws_secret.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secret.data["secret_key"]
  token = data.vault_generic_secret.aws_secret.data["security_token"]
  region  = var.region
}

resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "backends3bucket05"
  acl    = "private"
  region = var.region  
}

resource "aws_s3_bucket_object" "artifact" {
  key        = "artifacts01/ssl-test-jenkins-EBS-48.zip"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "ssl-test-jenkins-EBS-48.zip"  
}

resource "aws_elastic_beanstalk_application" "beanapp" {
  name        = "app-ver2"
  description = "test application 4 terraform"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tf-test-version-label"
  application = aws_elastic_beanstalk_application.beanapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.backend_S3_bucket.id
  key         = aws_s3_bucket_object.artifact.id
}
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-ebstalk-env"
  application         = aws_elastic_beanstalk_application.beanapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.0.0 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = aws_iam_instance_profile.ebs_inst_profile.name
  }
}

/* resource "aws_iam_role" "ebstalk_role" {
  name = "ebsservrole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudformationReadOperationsOnElasticBeanstalkStacks",
            "Effect": "Allow",
            "Action": [
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStacks"
            ],
            "Resource": [
                "arn:aws:cloudformation:*:*:stack/awseb-*",
                "arn:aws:cloudformation:*:*:stack/eb-*"
            ]
        },
        {
            "Sid": "AllowOperations",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeNotificationConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:PutNotificationConfiguration",
                "ec2:DescribeInstanceStatus",
                "ec2:AssociateAddress",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeSecurityGroups",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTargetGroups",
                "lambda:GetFunction",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl",
                "sns:Publish"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "AllowOperationsOnHealthStreamingLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:DeleteLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
        }
    ]
}
EOF
  
} */
resource "aws_iam_instance_profile" "ebs_inst_profile" {
  name = "instprofile"
  role = "AWSServiceRoleForElasticBeanstalk"
}

variable "region" {
  type    = string  
}
