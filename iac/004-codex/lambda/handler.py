import json

def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps({"status": "validation-pass", "event": event})
    }
