/*
This plan creates Elastik Beanstalk env and app. 
*/
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
  name                   = "${var.project_name}-env"
  application            = aws_elastic_beanstalk_application.beanapp.name
  solution_stack_name    = var.solution_stack
  wait_for_ready_timeout = "20m"

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_PORT"
    value     = "5000"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    resource  = "AWSEBAutoScalingLaunchConfiguration"
    value     = aws_iam_instance_profile.beanstalk_ec2.name
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
   setting {
    namespace = "aws:elb:listener"
    name      = "ListenerEnabled"
    value     = "false"
  }
    setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  } 
    setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "80"
  } 
    setting {
    namespace = "aws:elb:listener:443"
    name      = "InstanceProtocol"
    value     = "HTTP"
  }
    setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = "arn:aws:acm:us-east-2:632888177230:certificate/345cf844-7fc6-4bd5-94d4-cdb18744884a"
  }      
}

variable "solution_stack" {
  type = string
}

