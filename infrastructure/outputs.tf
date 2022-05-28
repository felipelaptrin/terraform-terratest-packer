output "s3_bucket_tags" {
  value = aws_s3_bucket.this.tags_all
}

output "ec2_dummy_tags" {
  value = aws_instance.dummy.tags_all
}
