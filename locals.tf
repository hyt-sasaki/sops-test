locals {
  account     = "146161350821"
  root_user   = "arn:aws:iam::${local.account}:root"
  normal_user = "arn:aws:iam::${local.account}:user/daily_use"
}
