resource "aws_iam_role" "kms_use" {
  name               = "kms_use_role"
  assume_role_policy = data.aws_iam_policy_document.kms_use_assume_policy.json
}

data "aws_iam_policy_document" "kms_use_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.gha.arn]
    }
  }
}

resource "aws_iam_role" "gha" {
  name               = "gha_role"
  assume_role_policy = data.aws_iam_policy_document.gha_assume_policy.json
}

data "aws_iam_policy_document" "gha_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [local.normal_user]
    }
  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:hyt-sasaki/sops-test:*"]
    }
  }
}
