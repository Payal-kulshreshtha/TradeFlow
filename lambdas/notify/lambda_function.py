import json
import os
import boto3

sns = boto3.client("sns")

def lambda_handler(event, context):
    topic_arn = os.environ["SNS_TOPIC_ARN"]

    notification_type = event.get("notification_type", "INFO")
    message = event.get("message", "TradeFlow notification")

    subject = f"TradeFlow - {notification_type}"

    payload = {
        "project": "TradeFlow",
        "notification_type": notification_type,
        "message": message,
        "execution_id": event.get("execution_id"),
        "details": event.get("details",{})
    }

    response = sns.publish(
        TopicArn=topic_arn,
        Subject=subject[:100],
        Message=json.dumps(payload, indent=2)
    )

    print(f"SNS notification sent: {response['MessageId']}")

    return {
        "status": "SUCCESS",
        "notification_type": notification_type,
        "message_id": response["MessageId"]
    }