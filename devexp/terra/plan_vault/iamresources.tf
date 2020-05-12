/*
This plan creates IAM policies, roles and inst. profiles 4 all inf. elements
*/
resource "aws_iam_instance_profile" "beanstalk_service" {
  name = "beanstalk-service-user"
  role = aws_iam_role.beanstalk_service.name
}

resource "aws_iam_instance_profile" "beanstalk_ec2" {
  name = "beanstalk-ec2-user"
  role = aws_iam_role.beanstalk_ec2.name
}

resource "aws_iam_role" "beanstalk_service" {
  name = "${var.project_name}-beanstalk-service-role"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"    = "",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "elasticbeanstalk.amazonaws.com"
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" = {
            "sts:ExternalId" = "elasticbeanstalk"
          }
        }
      }
    ]
  })

}

resource "aws_iam_role" "beanstalk_ec2" {
  name = "${var.project_name}-beanstalk-ec2-role"
  assume_role_policy = jsonencode({
    "Version" = "2008-10-17",
    "Statement" = [
      {
        "Sid"    = "",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })


}

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"
  assume_role_policy = jsonencode({
    "Version" = "2008-10-17",
    "Statement" = [
      {
        "Sid"    = "",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_policy" "lambda-cloudwatch-policy" {
  name = "${var.project_name}-lambda-cloudwatch-policy"
  path = "/"
  policy = jsonencode({

    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "logs:CreateLogGroup",
        "Resource" = "arn:aws:logs:${var.region}:${var.account_id}:*"
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" = [
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/Ebs-control1:*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_beanstalk_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"
}
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda-cloudwatch-policy.arn
}

resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}
resource "aws_iam_role_policy_attachment" "beanstalk_service_health" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
resource "aws_iam_role_policy_attachment" "beanstalk_service_lb" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}


resource "aws_iam_role_policy_attachment" "beanstalk_ec2_worker" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_web" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_container" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}


variable "account_id" {
  type = string
}
variable "region" {
  type = string
}
