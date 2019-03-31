
init:
	pipenv install
	pipenv lock -r > requirements.txt
	pip install -r requirements.txt -t build/
	cp -R src/* build/

deploy: init
	aws cloudformation package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket $(S3BUCKET)
	aws cloudformation deploy --template-file packaged.yaml --stack-name custom-resource-block-public-s3-buckets --capabilities CAPABILITY_IAM

deploy-stack:
	aws cloudformation deploy --template-file stack.yaml --stack-name block-public-s3-buckets
