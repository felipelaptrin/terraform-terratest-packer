package main

import (
	"strings"
	"testing"

	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../infrastructure",
	})
	EXPECTED_DEFAULT_TAGS := map[string]string{
		"Name":  "Flugel",
		"Owner": "InfraTeam",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate EC2 and S3
	resources_tags := [3]string{
		"ec2_dummy_tags",
		"s3_bucket_tags",
		"ec2_cluster_tags",
	}
	for i := 0; i < len(resources_tags); i++ {
		tag := terraform.OutputMap(t, terraformOptions, resources_tags[i])
		assert.Equal(t, EXPECTED_DEFAULT_TAGS, tag)
	}
	time.Sleep(30 * time.Second)
	// Validate static application
	DNS_ALB := "http://" + terraform.Output(t, terraformOptions, "alb_dns")
	http_helper.HttpGetWithCustomValidation(t, DNS_ALB, nil, func(status int, content string) bool {
		return status == 200 &&
			strings.Contains(content, "<img src=\"./static/logo.png\" alt=\"Flugel logo\" class=\"center\">")
	})
}
