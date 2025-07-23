module "jenkins_master_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role = true

  role_name         = "jenkins-master"
  role_requires_mfa = false

  custom_role_policy_arns = [
    aws_iam_policy.jenkins_master_policy.arn
  ]
  number_of_custom_role_policy_arns = 1

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]
}

module "jenkins_node_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role = true

  role_name         = "jenkins-node"
  role_requires_mfa = false

  custom_role_policy_arns = [
    aws_iam_policy.jenkins_node_policy.arn
  ]
  number_of_custom_role_policy_arns = 1

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]
}

resource "aws_iam_policy" "jenkins_node_policy" {
  name        = "jenkins_node_policy"
  path        = "/"
  description = "Jenkins node policy for S3 artifacts and ECR image pushes"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = [var.client_repo, var.server_repo]
      }
    ]
  })
}


resource "aws_iam_policy" "jenkins_master_policy" {
  name        = "jenkins_master_policy"
  path        = "/"
  description = "Jenkins master policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSpotInstanceRequests",
          "ec2:CancelSpotInstanceRequests",
          "ec2:GetConsoleOutput",
          "ec2:RequestSpotInstances",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRegions",
          "ec2:DescribeImages",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:GetPasswordData"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : module.jenkins_node_role.iam_role_arn
      },
      {
        "Effect" : "Allow",
        "Action" = [
          "iam:ListInstanceProfiles",
          "iam:CreateServiceLinkedRole",
          "iam:ListRoles"
        ]

        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins_master_profile" {
  name = "jenkins-master-instance-profile"
  role = module.jenkins_master_role.iam_role_name
}

resource "aws_iam_instance_profile" "jenkins_node_profile" {
  name = "jenkins-node-instance-profile"
  role = module.jenkins_node_role.iam_role_name
}