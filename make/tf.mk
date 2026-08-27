.PHONY: tf.fmt.ci tf.fmt tf.init.liu tf.ok tf.lint tf.lint.fix tf.scan tf.sec tf.plan tf.sec.plan tf.apply

tf.fmt:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -diff
tf.fmt.ci:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -check

tf.init.liu:
	@terraform -chdir=$(TF_ENV_DIR) init -lock=false -input=false -upgrade

tf.lint:
	@tflint --chdir=$(INFRA_DIR) --recursive
tf.lint.fix:
	@tflint --chdir=$(INFRA_DIR) --recursive --fix

tf.ok:
	@terraform -chdir=$(TF_ENV_DIR) validate

tf.scan:
	@checkov -d $(INFRA_DIR)
tf.sec:
	@trivy config $(INFRA_DIR) --exit-code 1 --severity HIGH,CRITICAL --ignorefile $(CURDIR)/.trivyignore.yaml

tf.plan:
	@terraform -chdir=$(TF_ENV_DIR) plan --out=tfplan
tf.sec.plan:
	@trivy config $(TF_ENV_DIR)/tfplan --exit-code 1 --severity HIGH,CRITICAL --ignorefile $(CURDIR)/.trivyignore.yaml
tf.apply: tf.sec.plan
	@terraform -chdir=$(TF_ENV_DIR) apply tfplan
