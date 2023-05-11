.PHONY: complete simple secrets keys diagnostic-settings certs cert-isssuer

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple ./key_vault_test.go

secrets:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/secrets ./key_vault_test.go

keys:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/keys ./key_vault_test.go

certs:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/certs ./key_vault_test.go

cert-issuer:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/cert-issuer ./key_vault_test.go

diagnostic-settings:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/diagnostic-settings ./key_vault_test.go
