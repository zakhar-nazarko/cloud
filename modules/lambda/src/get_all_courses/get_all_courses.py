import json
import boto3
import os

dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "eu-central-1"))

def lambda_handler(event, context):
    try:
        response = dynamodb.scan(TableName="courses")
        items = response.get("Items", [])

        courses = []
        for item in items:
            course = {
                "id": item["id"]["S"],
                "title": item["title"]["S"],
                "watchHref": item["watchHref"]["S"],
                "authorId": item["authorId"]["S"],
                "length": item["length"]["S"],
                "category": item["category"]["S"]
            }
            courses.append(course)

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "GET,OPTIONS"
            },
            "body": json.dumps(courses)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "GET,OPTIONS"
            },
            "body": json.dumps({"error": str(e)})
        }
