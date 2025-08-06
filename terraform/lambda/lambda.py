import boto3
import gzip
import json
import urllib.parse
import urllib3
import ssl

s3 = boto3.client('s3')
ssm = boto3.client('ssm')
http = urllib3.PoolManager(
    cert_reqs=ssl.CERT_NONE,
    ssl_version=ssl.PROTOCOL_TLS
)

SPLUNK_HEC_URL = "https://prd-p-ahb3m.splunkcloud.com:8088/services/collector"
SPLUNK_HEC_TOKEN = "/splunk/hec_token_alb"

def lambda_handler(event, context):
    token_response = ssm.get_parameter(Name=SPLUNK_HEC_TOKEN, WithDecryption=True)
    splunk_token = token_response['Parameter']['Value']

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'])

        try:
            response = s3.get_object(Bucket=bucket, Key=key)
            with gzip.GzipFile(fileobj=response['Body']) as gz:
                content = gz.read().decode('utf-8')
                lines = content.strip().split('\n')

                for line in lines:
                    send_to_splunk(line, splunk_token)

        except Exception as e:
            print(f"Error processing file {key} from bucket {bucket}: {e}")
            raise e

def send_to_splunk(event_line, token):
    data = {
        "event": event_line,
        "sourcetype": "aws:alb"
    }

    headers = {
        "Authorization": f"Splunk {token}",
        "Content-Type": "application/json"
    }

    encoded_data = json.dumps(data).encode('utf-8')
    response = http.request("POST", SPLUNK_HEC_URL, body=encoded_data, headers=headers)

    if response.status >= 300:
        print(f"Failed to send to Splunk: {response.status}, {response.data}")
