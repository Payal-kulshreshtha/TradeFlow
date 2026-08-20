import json
import os
from datetime import datetime, timezone

import boto3
import urllib.request

s3 = boto3.client("s3")

def lambda_handler(event,context):
    api_url = os.environ["API_URL"]
    bucket = os.environ["S3_BUCKET"]

    print(f"Calling trade API: {api_url}")

    request = urllib.request.Request(
        api_url,
        headers={
            "User-Agent": "Mozilla/5.0"
        }
    )

    with urllib.request.urlopen(request, timeout= 30) as response:
        data = json.loads(response.read().decode("utf-8"))

    timestamp = datetime.now(timezone.utc)

    file_name = (
        f"raw/{timestamp:%Y/%m/%d}/"
        f"trades_{timestamp:%Y%m%d_%H%M%S}.json"
    )

    s3.put_object(
        Bucket=bucket,
        Key=file_name,
        Body=json.dumps(data),
        ContentType = "application/json"
    )

    print(f"Raw trade data stored at s3://{bucket}/{file_name}")

    return {
        "status": 200,
        "bucket": bucket,
        "key": file_name,
        "api_url": api_url
    }