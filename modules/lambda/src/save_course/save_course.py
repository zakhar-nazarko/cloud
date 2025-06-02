import json
import boto3
import os
import re

dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "us-east-1"))

def replace_all(text, find, replace):
    return re.sub(find, replace, text)

def lambda_handler(event, context):
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "POST,OPTIONS"
    }

    try:
        body = json.loads(event.get("body", "{}"))

        required_fields = ["title", "authorId", "length", "category"]
        for field in required_fields:
            if field not in body:
                return {
                    "statusCode": 400,
                    "headers": headers,
                    "body": json.dumps({"error": f"Missing required field: {field}"})
                }

        course_id = replace_all(body["title"], r"\s+", "-").lower()

        item = {
            "id": {"S": course_id},
            "title": {"S": body["title"]},
            "watchHref": {"S": f"http://www.pluralsight.com/courses/{course_id}"},
            "authorId": {"S": body["authorId"]},
            "length": {"S": body["length"]},
            "category": {"S": body["category"]}
        }

        dynamodb.put_item(TableName="courses", Item=item)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "id": course_id,
                "title": body["title"],
                "watchHref": f"http://www.pluralsight.com/courses/{course_id}",
                "authorId": body["authorId"],
                "length": body["length"],
                "category": body["category"]
            })
        }

    except Exception as e:
        print("Error saving course:", e)
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }
