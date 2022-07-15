output "s3_bucket_tags" {
  value = aws_s3_bucket.this.tags_all
}

output "ec2_dummy_tags" {
  value = aws_instance.dummy.tags_all
}

output "ec2_cluster_tags" {
  value = aws_instance.dummy.tags_all
}

output "ami_static_webapp" {
  value = data.aws_ami.static_webapp.id
}

output "alb_dns" {
  value = aws_alb.this.dns_name
}
