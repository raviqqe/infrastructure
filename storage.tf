resource "google_storage_bucket" "raviqqe" {
  name                        = "raviqqe"
  location                    = "US"
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "raviqqe" {
  bucket = "raviqqe"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
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

resource "aws_s3_bucket_ownership_controls" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "raviqqe" {
  bucket = aws_s3_bucket.raviqqe.id

  versioning_configuration {
    status = "Enabled"
  }
}
