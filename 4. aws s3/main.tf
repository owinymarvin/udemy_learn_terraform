provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "finance" {
  bucket = "finance-dmtf-250806"
  tags = {
    Name        = "Finance Bucket"
    Environment = "Dev"
    Description = "Test finance Bucket creqted by terraform"
  }
  force_destroy = true
}

resource "aws_s3_object" "finance-object" {
  bucket = aws_s3_bucket.finance.id
  key    = "Benefits_of_Infrastructure_As_Code.pdf"
  source = "C:/Users/MarvinO/Downloads/Benefits_of_Infrastructure_As_Code.pdf"
  etag   = filemd5("C:/Users/MarvinO/Downloads/Benefits_of_Infrastructure_As_Code.pdf")
}

data "aws_iam_group" "finance_data" {
  group_name = "terraform"
}

resource "aws_s3_bucket_policy" "finance_policy" {
  bucket = aws_s3_bucket.finance.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = [
          aws_s3_bucket.finance.arn,
          "${aws_s3_bucket.finance.arn}/*"
        ]
        Principal = "*"
      }
    ]
  })
}
resource "aws_s3_bucket_public_access_block" "finance_public_access" {
  bucket = aws_s3_bucket.finance.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
