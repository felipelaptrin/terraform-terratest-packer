# terraform-terratest

## About the project

This is a project for deploying resources in AWS using the following stack:
- Terraform
- Terratest
- Github Actions

It is responsible for creating VPC, S3 bucket, EC2 instance.

![Resources created with Terraform](docs/terraform.png)

## Project tree

```
├── docs                    # Contains assets for documenting the project
├── infrastructure          # Contains all the manifests written in Terraform
└── tests                   # Contains all the tests used to validate the Terraform manifests
```

## Workflow

There is a single workflow in this projects. It is responsible for: 
- Run tests made with Terratest
- Run terraform-docs action to automatically create documentation