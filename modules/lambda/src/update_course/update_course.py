import json
import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "us-east-1"))

def lambda_handler(event, context):
    try:
        # Construct item from event
        item = {
            "id": {"S": event["id"]},
            "title": {"S": event["title"]},
            "watchHref": {"S": event["watchHref"]},
            "authorId": {"S": event["authorId"]},
            "length": {"S": event["length"]},
            "category": {"S": event["category"]}
        }

        # Put item into DynamoDB table
        dynamodb.put_item(
            TableName="courses",
            Item=item
        )

        # Return the saved item as response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "id": event["id"],
                "title": event["title"],
                "watchHref": event["watchHref"],
                "authorId": event["authorId"],
                "length": event["length"],
                "category": event["category"]
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
