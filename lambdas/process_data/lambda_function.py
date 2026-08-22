import json
import os
from datetime import datetime, timezone
import boto3

s3 = boto3.client("s3")
def lambda_handler(event, context):
    print(f"Process Lambda recived event: {json.dumps(event)}")

    bucket = event["bucket"]
    raw_key = event["key"]

    print(f"Reading raw file: s3://{bucket}/{raw_key}")

    response = s3.get_object(
        Bucket=bucket,
        Key=raw_key
    )

    raw_data = json.loads(response["Body"].read().decode("utf-8"))

    products = raw_data.get("products", [])

    processed_trade =[]

    for record in products:
        processed_data = {
            "trade_id": f"TRD-{record.get("id")}",
            "instrument": record.get("title"),
            "price": record.get("price"),
            "quantity": record.get("stock"),
            "trade_value" : record.get("price", 0) * record.get("stock", 0),
            "processed_at": datetime.now(timezone.utc).isoformat()
        }

        processed_trade.append(processed_data)

    timestamp = datetime.now(timezone.utc)

    processed_key = (
        f"processed/"
        f"{timestamp:%Y/%m/%d}/"
        f"processed_trades_{timestamp:%Y%m%d_%H%M%S}.json"
    )

    s3.put_object(
        Bucket=bucket,
        Key=processed_key,
        Body=json.dumps(processed_trade, indent=2),
        ContentType="application/json"
    )

    print(
        f"Processed file written to "
        f"s3://{bucket}/{processed_key}"
    )

    return {
        "status": "SUCCESS",
        "bucket": bucket,
        "raw_key": raw_key,
        "processed_key": processed_key,
        "record_count": len(processed_trade)
    }
    