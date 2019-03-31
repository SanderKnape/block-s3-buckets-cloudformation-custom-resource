# CloudFormation custom resource for blocking public S3 buckets for an entire account

The custom resource in this repository enables you to use the newly added S3 feature for [blocking the creation of public S3 buckets in an AWS account](https://aws.amazon.com/blogs/aws/amazon-s3-block-public-access-another-layer-of-protection-for-your-accounts-and-buckets/). Please read my blog post for more information: [blocking account-wide creation of public S3 buckets through a CloudFormation custom resource](https://sanderknape.com/2018/11/blocking-account-wide-creation-public-s3-buckets-cloudformation-custom-resource/).

Note that this custom resource enables all features for blocking the creation of public S3 buckets. See the original blog post linked above for more information on the different features now available.

## Requirements

* AWS CLI with Administrator permission
* [Python 3 installed](https://www.python.org/downloads/)
* [Pipenv installed](https://github.com/pypa/pipenv)
    - `pip install pipenv`

## Usage

First, change the first line in the [Makefile](/Makefile) to specify your S3 bucket to which to upload the SAM artifacts. Then, run the following command to deploy the stack:

```bash
make deploy
```

This first will initialize your environment using the following steps:

* Setup a virtual environment using pipenv
* Download the dependencies into the `build/` directory
* Copy the source code into the `build/` directory

You can now start using this custom resource. An example on how to use it is in the [stack.yaml](/stack.yaml) file. You can deploy this stack using the following command:

```bash
make deploy-stack
```
