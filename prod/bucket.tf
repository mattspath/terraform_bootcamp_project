
data "archive_file" "random" {
  type        = "zip"
  source_dir  = "../lambda"
  output_path = "${path.module}/lambda_artifact.zip"
}



resource "aws_s3_bucket" "main" {
  bucket = "terraformbootcamplambda-${local.env}-1"
  tags   = local.tags
}


resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]
  bucket     = aws_s3_bucket.main.id
  acl        = "private"
}

resource "aws_s3_bucket_object" "main" {
  bucket = aws_s3_bucket.main.id
  key    = "lambda_artifact.zip"
  source = data.archive_file.random.output_path
}