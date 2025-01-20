resource "aws_s3_bucket" "zeus" {
  bucket = "zeus-${local.s3_sufix}"
}