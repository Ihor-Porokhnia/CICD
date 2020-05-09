
resource "aws_elastic_beanstalk_application" "beanapp" {
  name        = "${var.project_name}-app"
  description = "test application 4 terraform"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "${var.project_name}-${var.artifact_name}"
  application = aws_elastic_beanstalk_application.beanapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.backend_S3_bucket.id
  key         = aws_s3_bucket_object.artifact.id
  depends_on = [
    aws_elastic_beanstalk_environment.api,
  ]
}

resource "aws_elastic_beanstalk_environment" "api" {
    name = "${var.project_name}-env"
    application = aws_elastic_beanstalk_application.beanapp.name
    solution_stack_name = "64bit Amazon Linux 2 v3.0.1 running Corretto 11"
    wait_for_ready_timeout = "20m"
  
    setting {
    namespace = "aws:elasticbeanstalk:application:environment"
        name = "SERVER_PORT"
        value = "5000"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "InstanceType"
        value     = "t2.micro"
    } 
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "ServiceRole"
        value     = "aws-elasticbeanstalk-service-role"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        resource  = "AWSEBAutoScalingLaunchConfiguration"
        value     = "aws-elasticbeanstalk-ec2-role"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "Availability Zones"
        value = "Any 2"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MinSize"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        value = "2"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "RollingUpdateEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "RollingUpdateType"
        value = "Health"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "MinInstancesInService"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "MaxBatchSize"
        value = "1"
    }
    setting {
        namespace = "aws:elb:loadbalancer"
        name = "CrossZone"
        value = "true"
  }

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

resource "aws_iam_role_policy_attachment" "beanstalk_service" {   
    role = ws_iam_role.beanstalk_service.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_health" {   
    role = aws_iam_role.beanstalk_service.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
resource "aws_iam_role_policy_attachment" "beanstalk_service_lb" {    
    role = aws_iam_role.beanstalk_service.name
    policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}


resource "aws_iam_role_policy_attachment" "beanstalk_ec2_worker" {    
    role = aws_iam_role.beanstalk_ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_web" {    
    role = aws_iam_role.beanstalk_ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_container" {    
    role = aws_iam_role.beanstalk_ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}



variable "region" {
  type    = string  
}
