package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestLinodeDefault(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Root of the module
		TerraformDir: "../",
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"./examples/linode/default/terraform.tfvars"},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}