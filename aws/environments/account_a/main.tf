resource "aws_iam_role" "test" {
  name               = "test-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.test[0].json
}

data "aws_iam_policy_document" "test" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
