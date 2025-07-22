resource "aws_ecr_lifecycle_policy" "client" {
  policy = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "rulePriority": 1,
      "selection": {
        "countNumber": 5,
        "countType": "imageCountMoreThan",
        "tagPatternList": [
          "main*",
          "dev*"
        ],
        "tagStatus": "tagged"
      }
    },
    {
      "action": {
        "type": "expire"
      },
      "rulePriority": 2,
      "selection": {
        "countNumber": 3,
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
POLICY

  repository = "chessu/client"
}

resource "aws_ecr_lifecycle_policy" "server" {
  policy = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "rulePriority": 1,
      "selection": {
        "countNumber": 5,
        "countType": "imageCountMoreThan",
        "tagPatternList": [
          "main*",
          "dev*"
        ],
        "tagStatus": "tagged"
      }
    },
    {
      "action": {
        "type": "expire"
      },
      "rulePriority": 2,
      "selection": {
        "countNumber": 3,
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
POLICY

  region     = "us-east-1"
  repository = "chessu/server"
}
