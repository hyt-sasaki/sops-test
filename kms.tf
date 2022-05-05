resource "aws_kms_key" "dagger" {
  description = "key for dagger CI/CD"
  policy      = data.aws_iam_policy_document.key_policy_document.json
}

data "aws_iam_policy_document" "key_policy_document" {
  statement {
    sid = "Enable IAM User Permissions"
    principals {
      type        = "AWS"
      identifiers = [local.root_user]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid = "Allow access for Key Administrators"
    principals {
      type        = "AWS"
      identifiers = [local.normal_user]
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
    sid = "Allow use of the key"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.kms_use.arn]
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
      identifiers = [local.normal_user]
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
