<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.15.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_instance.dummy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| <a name="input_ec2_ami"></a> [ec2\_ami](#input\_ec2\_ami) | AMI to be used in EC2 instances. Defaults to one eligible for free tier. | `string` | `"ami-09d56f8956ab235b3"` | no |
| <a name="input_ec2_type"></a> [ec2\_type](#input\_ec2\_type) | EC2 instance type. Defaults to one eligible for free tier. | `string` | `"t2.micro"` | no |
| <a name="input_network_ip"></a> [network\_ip](#input\_network\_ip) | CIDR block of the VPC Network | `string` | `"172.20.0.0"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the the s3 bucket that will be created | `string` | `"dummy-s3-bucket-flat"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_dummy_tags"></a> [ec2\_dummy\_tags](#output\_ec2\_dummy\_tags) | n/a |
| <a name="output_s3_bucket_tags"></a> [s3\_bucket\_tags](#output\_s3\_bucket\_tags) | n/a |
<!-- END_TF_DOCS -->