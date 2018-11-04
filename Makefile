all:

s3bucket:
	aws cloudformation describe-stacks --output text \
	--query 'Stacks[?StackName==`codedeploy-codedeploy`].Outputs[]|[?OutputKey==`BucketName`].OutputValue'

push:
	@$(eval S3 := $(shell aws cloudformation describe-stacks --output text \
			--query 'Stacks[?StackName==`codedeploy-codedeploy`].Outputs[]|[?OutputKey==`BucketName`].OutputValue'))
	@echo push $(S3) bucket
	aws deploy push \
		--application-name cicd-sample-app \
		--ignore-hidden-files \
		--description "add sleep 60" \
		--s3-location s3://$(S3)/SampleApp_Linux.zip \
		--source .
