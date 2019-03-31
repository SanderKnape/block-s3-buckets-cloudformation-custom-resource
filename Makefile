all: deploy-stack
.PHONY: clean build build-lambda deploy deploy-stack destroy-stack

clean:
	-rm -rf pkg requirements.txt Pipfile.lock templates/packaged.yaml

build: build-lambda
deploy: deploy-stack

requirements.txt:
	@echo 'Building requirements list...'
	@pipenv install
	@pipenv lock -r > requirements.txt

pkg: requirements.txt
	@echo 'Building lambda package from requirements and source...'
	@pip install -r requirements.txt -t pkg/
	@cp src/publicbuckets.py pkg/

templates/packaged.yaml: pkg
	@echo 'Attempting to compile cloudformation from template...'
ifdef AWS_DEFAULT_PROFILE
ifdef S3_BUCKET
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation package --template-file templates/template.yaml --output-template-file templates/packaged.yaml --s3-bucket $(S3_BUCKET)
else
	@aws cloudformation package --template-file templates/template.yaml --output-template-file templates/packaged.yaml --s3-bucket $(S3_BUCKET)
endif
endif

build-lambda: templates/packaged.yaml

deploy-stack: build-lambda
ifdef AWS_DEFAULT_PROFILE
ifdef LAMBDA_STACK_NAME
ifdef CFN_STACK_NAME
	@echo "Attempting to deploy compiled cloudformation to $(AWS_DEFAULT_PROFILE)..."
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation deploy --template-file templates/packaged.yaml --stack-name $(LAMBDA_STACK_NAME) --capabilities CAPABILITY_IAM
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation deploy --template-file templates/stack.yaml --stack-name $(CFN_STACK_NAME)
else
	@echo 'Attempting to deploy compiled cloudformation to AWS account...'
	@aws cloudformation deploy --template-file templates/packaged.yaml --stack-name $(LAMBDA_STACK_NAME) --capabilities CAPABILITY_IAM
	@aws cloudformation deploy --template-file templates/stack.yaml --stack-name $(CFN_STACK_NAME)
endif
endif
endif

destroy-stack:
ifdef AWS_DEFAULT_PROFILE
ifdef CFN_STACK_NAME
ifdef LAMBDA_STACK_NAME
	@echo "Attempting to destroy stack in $(AWS_DEFAULT_PROFILE)..."
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation delete-stack --stack-name $(CFN_STACK_NAME)
	@echo "Waiting for $(CFN_STACK_NAME) to be deleted..."
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation wait stack-delete-complete --stack-name $(CFN_STACK_NAME)
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation delete-stack --stack-name $(LAMBDA_STACK_NAME)
	@echo "Waiting for $(LAMBDA_STACK_NAME) to be deleted..."
	@aws --profile $(AWS_DEFAULT_PROFILE) cloudformation wait stack-delete-complete --stack-name $(LAMBDA_STACK_NAME)
else
	@echo 'Attempting to destroy stack in AWS account...'
	@aws cloudformation delete-stack --stack-name $(CFN_STACK_NAME)
	@echo "Waiting for $(CFN_STACK_NAME) to be deleted..."
	@aws cloudformation wait stack-delete-complete --stack-name $(CFN_STACK_NAME)
	@aws cloudformation delete-stack --stack-name $(LAMBDA_STACK_NAME)
	@echo "Waiting for $(LAMBDA_STACK_NAME) to be deleted..."
	@aws cloudformation wait stack-delete-complete --stack-name $(LAMBDA_STACK_NAME)
endif
endif
endif
