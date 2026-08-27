.PHONY: aws.vpcs
aws.vpcs:
	@aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output table
