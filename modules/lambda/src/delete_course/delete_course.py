import json
import boto3
import os

dynamodb = boto3.client('dynamodb', region_name=os.environ.get("AWS_REGION", "eu-central-1"))

def lambda_handler(event, context):
    try:
        # Expecting the event to be a JSON with an "id" field
        course_id = event.get("id")
        if not course_id:
            return {
                "statusCode": 400,
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
            "body": json.dumps({"message": "Course deleted", "details": response})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
