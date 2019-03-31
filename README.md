# CloudFormation custom resource for blocking public S3 buckets for an entire account

The custom resource in this repository enables you to use the newly added S3 feature for [blocking the creation of public S3 buckets in an AWS account](https://aws.amazon.com/blogs/aws/amazon-s3-block-public-access-another-layer-of-protection-for-your-accounts-and-buckets/). Please read my blog post for more information: [blocking account-wide creation of public S3 buckets through a CloudFormation custom resource](https://sanderknape.com/2018/11/blocking-account-wide-creation-public-s3-buckets-cloudformation-custom-resource/).

Note that this custom resource enables all features for blocking the creation of public S3 buckets. See the original blog post linked above for more information on the different features now available.

## Requirements

* AWS CLI with Administrator permission
* [Python 3 installed](https://www.python.org/downloads/)
* [Pipenv installed](https://github.com/pypa/pipenv)
    - `pip install pipenv`

## Usage

The project includes a Makefile to automate the build, and deployment of the necessary resources to the target AWS account using CloudFormation.
Before running make, set the following three variables, either in the environment, or by passing them to the make executable using environment overrides
* S3_BUCKET
* LAMBDA_STACK_NAME
* CFN_STACK_NAME

AWS_DEFAULT_PROFILE is optional, as its intent is to support those who have more than one AWS account

Once you decided how you are going to pass the environment variables to Make, running ```make``` without any targets will build, and deploy the stack to your account

### Examples:
```bash
export S3_BUCKET=my_bucket
export LAMBDA_STACK_NAME=lambda-blockpublicbuckets
export CFN_STACK_NAME=policy-blockpublicbuckets
export AWS_DEFAULT_PROFILE=123456789012
make
```
**or**
```bash
make \
-e AWS_DEFAULT_PROFILE=123456789012 \
-e S3_BUCKET=my_bucket \
-e LAMBDA_STACK_NAME=lambda-blockpublicbuckets \
-e CFN_STACK_NAME=policy-blockpublicbuckets
```

## Options
The Makefile provides the following targets:
* **clean** - Purges the build directory, cached packages, and compiled templates
* **build** - Caches packages, compiles the template, and uploads to the target S3 bucket
* **deploy** - Deploys the compiled CloudFormation templates, and executes the templates containing the lambda function in the account
* **destroy-stack** - Deletes the two active stacks from the account, reversing the policy defined by the lambda function
