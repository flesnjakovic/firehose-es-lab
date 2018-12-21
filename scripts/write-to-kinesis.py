import boto3
import pandas as pd
import json

DeliveryStreamName = 'firehose-es-lab-stream'
client = boto3.client('firehose')

data = pd.read_csv('../data/googleplaystore_user_reviews.csv')

record = {}

for i in range(0, len(data.iloc[:,0])):
    record['App'] = data.iloc[i]['App']
    record['Review'] = data.iloc[i]['Translated_Review']
    record['Sentiment'] = data.iloc[i]['Sentiment']
    record['Sentiment_Polarity'] = data.iloc[i]['Sentiment_Polarity']
    record['Sentiment_Subjectivity'] = data.iloc[i]['Sentiment_Subjectivity']
    response = client.put_record(
        DeliveryStreamName=DeliveryStreamName,
        Record={
            'Data': json.dumps(record)
        }
    )
    print('PUTTING RECORD TO KINESIS: \n' + str(record))
