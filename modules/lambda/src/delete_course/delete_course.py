import json
import boto3
import os

dynamodb = boto3.client('dynamodb', region_name=os.environ.get("AWS_REGION", "eu-central-1"))

def lambda_handler(event, context):
    try:
        course_id = None

        if "body" in event and event["body"]:
            try:
                body = json.loads(event["body"])
                course_id = body.get("id")
            except json.JSONDecodeError:
                pass

        if not course_id and event.get("queryStringParameters"):
            course_id = event["queryStringParameters"].get("id")

        if not course_id and event.get("pathParameters"):
            course_id = event["pathParameters"].get("id")

        if not course_id:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "Content-Type",
                    "Access-Control-Allow-Methods": "OPTIONS,DELETE"
                },
                "body": json.dumps({"error": "Missing 'id' in request"})
            }

        response = dynamodb.delete_item(
            TableName="courses",
            Key={
                "id": {"S": course_id}
            }
        )

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,DELETE"
            },
            "body": json.dumps({"message": "Course deleted", "id": course_id})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "OPTIONS,DELETE"
            },
            "body": json.dumps({"error": str(e)})
        }
