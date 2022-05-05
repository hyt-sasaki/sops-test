resource "aws_iam_role" "kms_use" {
  name               = "kms_use_role"
  assume_role_policy = data.aws_iam_policy_document.kms_use_assume_policy.json
}

data "aws_iam_policy_document" "kms_use_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [local.normal_user]
    }
    // 後でOIDCの設定を追加
  }
}
