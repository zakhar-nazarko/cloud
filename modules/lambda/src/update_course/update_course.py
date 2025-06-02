import json
import boto3
import os

dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "us-east-1"))

def lambda_handler(event, context):
    try:
        body = json.loads(event["body"]) if "body" in event else event

        item = {
            "id": {"S": body["id"]},
            "title": {"S": body["title"]},
            "watchHref": {"S": body["watchHref"]},
            "authorId": {"S": body["authorId"]},
            "length": {"S": body["length"]},
            "category": {"S": body["category"]}
        }

        dynamodb.put_item(
            TableName="courses",
            Item=item
        )

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,PUT"
            },
            "body": json.dumps({
                "id": body["id"],
                "title": body["title"],
                "watchHref": body["watchHref"],
                "authorId": body["authorId"],
                "length": body["length"],
                "category": body["category"]
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,PUT"
            },
            "body": json.dumps({"error": str(e)})
        }
