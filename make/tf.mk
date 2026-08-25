.PHONY: tf.fmt.ci tf.fmt
tf.fmt:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -diff
tf.fmt.ci:
	@terraform -chdir=$(INFRA_DIR) fmt -recursive -check
