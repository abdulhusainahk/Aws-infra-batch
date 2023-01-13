import boto3
import uuid, logging
from flask import Flask
import sys, psycopg2, os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
bucket_name=os.environ['s3bucketname']

filename='test.csv'

import pandas as pd
from io import StringIO

app = Flask(__name__)

@app.route('/')
def helloworld():
    return 'This is my Home API call Page \n Check /batch endpoint for import s3!'
@app.route('/Health')
def loadbalancerHealthCheck():
    data = {"status": "success"}
    return data, 200

@app.route('/batch')
def fetchBatch():
    download_path = '/tmp/{}{}'.format(uuid.uuid4(), filename)
    
    s3_client.download_file(bucket_name, filename,download_path)
    try:
        conn = psycopg2.connect(host=os.environ['dbhost'], user=os.environ['dbuser'], password=os.environ['dbpasswd'], database=os.environ['dbname'],port=5431)
    except Exception as e:
        logger.error("ERROR: Unexpected error: Could not connect to Postgres instance.")
        logger.error(e)
        sys.exit()

    logger.info("SUCCESS: Connection to RDS mysql instance succeeded")
    cur = conn.cursor()
    # Open the input file for copy
    f = open(download_path, "r")
    # Load csv file into the table
    
    cur.copy_expert("COPY target_table FROM stdin DELIMITER \',\' CSV header;", f)
    cur.execute("commit;")
    cur.execute("select * from target_table")
    s = "<table style='border:1px solid red'>"    
    for row in cur:    
        s = s + "<tr>"    
        for x in row:    
            s = s + "<td>" + str(x) + "</td>"    
        s = s + "</tr>" 
    print("Loaded data into {}".format("target_table"))
#    val = cur.fetchall()
    conn.close()
    print("DB connection closed.")
    return "<html><body><h5>File loaded into RDS</h5><br>" + s + "</body></html>" 

     