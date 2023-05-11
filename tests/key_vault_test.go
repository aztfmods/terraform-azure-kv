package main

import (
	"testing"

	"github.com/aztfmods/module-azurerm-kv/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := []shared.TestCase{
		{Name: "simple", Path: "../examples/simple"},
		{Name: "diagnostic-settings", Path: "../examples/diagnostic-settings"},
		{Name: "secrets", Path: "../examples/secrets"},
		{Name: "certs", Path: "../examples/certs"},
		{Name: "cert-issuer", Path: "../examples/cert-issuer"},
		{Name: "keys", Path: "../examples/keys"},
	}

	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			terraformOptions := shared.GetTerraformOptions(test.Path)

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer shared.Cleanup(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}
