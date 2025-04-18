resource "google_storage_bucket" "raviqqe" {
  name          = "raviqqe"
  location      = "US"
  storage_class = "COLDLINE"
}

resource "aws_s3_bucket" "raviqqe" {
  bucket = "raviqqe"
}


resource "aws_s3_bucket_cors_configuration" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://pen-lang.org", "https://raviqqe.com"]
    expose_headers  = ["etag"]
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id
  name   = "main"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
}
