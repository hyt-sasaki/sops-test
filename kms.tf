terraform {
  backend "s3" {
    bucket = "hytssk-remote-tfstate"
    region = "ap-northeast-1"
    key    = "resources/kms/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_kms_key" "dagger" {
  description = "key for dagger CI/CD"
  policy      = data.aws_iam_policy_document.key_policy_document.json
}

data "aws_iam_policy_document" "key_policy_document" {
  statement {
    sid = "Enable IAM User Permissions"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::146161350821:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid = "Allow access for Key Administrators"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::146161350821:user/daily_use"]
    }
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
  }
  statement {
    sid = "Allowaccess for Key Administrators"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::146161350821:user/daily_use"]
    }
    resources = ["*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
  }
  statement {
    sid = "Allow use of the key"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::146161350821:user/daily_use"]
    }
    resources = ["*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
  }
  statement {
    sid = "Allow attachment of persistent resources"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::146161350821:user/daily_use"]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = [true]
    }
    resources = ["*"]
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
  }
}
