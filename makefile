TF_ENGINE:=opentofu
AWS_PROFILE:=default

ifeq ($(TF_ENGINE), terraform)
	TF_BINARY:=terraform
else ifeq ($(TF_ENGINE), opentofu)	
	TF_BINARY:=tofu
endif

fmt:
	$(TF_BINARY) fmt -recursive

val:
	AWS_PROFILE=$(AWS_PROFILE) $(TF_BINARY) validate
	
init:
	AWS_PROFILE=$(AWS_PROFILE) $(TF_BINARY) init

plan:
	AWS_PROFILE=$(AWS_PROFILE) $(TF_BINARY) plan -out otplan

apply:
	AWS_PROFILE=$(AWS_PROFILE) $(TF_BINARY) apply otplan	