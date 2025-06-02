import json
import boto3
import os

dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "eu-central-1"))

def lambda_handler(event, context):
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "GET,OPTIONS"
    }

    try:
        course_id = event.get("pathParameters", {}).get("id")
        if not course_id:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing 'id' in path parameters"})
            }

        response = dynamodb.get_item(
            TableName="courses",
            Key={"id": {"S": course_id}}
        )

        item = response.get("Item")
        if not item:
            return {
                "statusCode": 404,
                "headers": headers,
                "body": json.dumps({"error": "Course not found"})
            }

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
            "headers": headers,
            "body": json.dumps(course)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }
