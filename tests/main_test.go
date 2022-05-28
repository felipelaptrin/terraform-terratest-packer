package main

import (
	"testing"

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

	ec2_dummy_tags := terraform.OutputMap(t, terraformOptions, "ec2_dummy_tags")
	s3_bucket_tags := terraform.OutputMap(t, terraformOptions, "s3_bucket_tags")

	assert.Equal(t, EXPECTED_DEFAULT_TAGS, ec2_dummy_tags)
	assert.Equal(t, EXPECTED_DEFAULT_TAGS, s3_bucket_tags)
}
