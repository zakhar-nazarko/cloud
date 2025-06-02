import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('authors')

def lambda_handler(event, context):
    try:
        response = table.scan()
        items = response.get('Items', [])

        authors = [
            {
                'id': item.get('id'),
                'firstName': item.get('firstName'),
                'lastName': item.get('lastName')
            }
            for item in items
        ]

        return {
            'statusCode': 200,
            'headers': {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "GET,OPTIONS"
            },
            'body': json.dumps(authors)
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "GET,OPTIONS"
            },
            'body': json.dumps({
                'message': 'Failed to retrieve authors',
                'error': str(e)
            })
        }
