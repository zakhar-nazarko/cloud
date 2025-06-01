import json
import boto3
import os
import re

# Initialize DynamoDB client
dynamodb = boto3.client("dynamodb", region_name=os.environ.get("AWS_REGION", "us-east-1"))


def replace_all(text, find, replace):
    return re.sub(find, replace, text)


def lambda_handler(event, context):
    try:
        # Create hyphenated, lowercase ID from title
        course_id = replace_all(event["title"], r"\s+", "-").lower()

        # Construct item
        item = {
            "id": {"S": course_id},
            "title": {"S": event["title"]},
            "watchHref": {"S": f"http://www.pluralsight.com/courses/{course_id}"},
            "authorId": {"S": event["authorId"]},
            "length": {"S": event["length"]},
            "category": {"S": event["category"]}
        }

        # Save item to DynamoDB
        dynamodb.put_item(
            TableName="courses",
            Item=item
        )

        # Return saved item
        return {
            "statusCode": 200,
            "body": json.dumps({
                "id": course_id,
                "title": event["title"],
                "watchHref": f"http://www.pluralsight.com/courses/{course_id}",
                "authorId": event["authorId"],
                "length": event["length"],
                "category": event["category"]
            })
        }

    except Exception as e:
        print("Error saving course:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
