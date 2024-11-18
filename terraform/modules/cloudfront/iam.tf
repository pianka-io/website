resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_policy.json
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront_origin_access"
}

data "aws_iam_policy_document" "cloudfront_policy" {
  statement {
    sid = "1"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]
  }
}
