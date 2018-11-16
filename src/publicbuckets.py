import os
import boto3
from cfn_lambda_handler import Handler

client = boto3.client('s3control')
handler = Handler()

@handler.create
@handler.update
def handle(event, context):
    client.put_public_access_block(
        AccountId=os.environ['ACCOUNT_ID'],
        PublicAccessBlockConfiguration={
            'BlockPublicAcls': True,
            'IgnorePublicAcls': True,
            'BlockPublicPolicy': True,
            'RestrictPublicBuckets': True
        }
    )

    return { "Status": "SUCCESS" }

@handler.delete
def handle_delete(event, context):
    client.delete_public_access_block(
        AccountId=os.environ['ACCOUNT_ID']
    )

    return { "Status": "SUCCESS" }
