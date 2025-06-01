import json
import boto3
import os

# Initialize DynamoDB client
dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "eu-central-1"))

def lambda_handler(event, context):
    try:
        course_id = event.get("id")
        if not course_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'id' in request"})
            }

        params = {
            "TableName": "courses",
            "Key": {
                "id": {"S": course_id}
            }
        }

        response = dynamodb.get_item(**params)

        item = response.get("Item")
        if not item:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": "Course not found"})
            }

        # Construct course object from DynamoDB item
        course = {
            "id": item["id"]["S"],
            "title": item["title"]["S"],
            "watchHref": item["watchHref"]["S"],
            "authorId": item["authorId"]["S"],
            "length": item["length"]["S"],
            "category": item["category"]["S"]
        }

        return {
            "statusCode": 200,
            "body": json.dumps(course)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
