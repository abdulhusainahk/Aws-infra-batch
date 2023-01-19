import boto3
import uuid, logging
from flask import Flask
import sys, psycopg2,os, traceback

logger = logging.getLogger()
logger.setLevel(logging.INFO)
ref_dictionary={
    "purchase_history.csv":"parchase_history_table",
    "customers.csv":"customers_table",
    "products.csv":"products_table"
}
s3_client = boto3.client('s3')
bucket_name=os.environ['s3bucketname']

def get_most_recent_s3_object(bucket_name):
    paginator = s3_client.get_paginator( "list_objects_v2" )
    page_iterator = paginator.paginate(Bucket=bucket_name)
    latest = None
    for page in page_iterator:
        if "Contents" in page:
            latest2 = max(page['Contents'], key=lambda x: x['LastModified'])
            if latest is None or latest2['LastModified'] > latest['LastModified']:
                latest = latest2
    return latest

app = Flask(__name__)

@app.route('/')
def helloworld():
    return 'This is my Home API call Page \n Check /batch endpoint for import s3!'

@app.route('/Health')
def loadbalancerHealthCheck():
    data = {"status": "success"}
    return data, 200

@app.route('/batch')
def UploadData():
    latest = get_most_recent_s3_object(bucket_name)
    filename=latest['Key']
    download_path = '/tmp/{}{}'.format(uuid.uuid4(), filename)
    table_name=ref_dictionary[filename]
    s3_client.download_file(bucket_name, filename,download_path)
    try:
        conn = psycopg2.connect(host=os.environ['dbhost'], user=os.environ['dbuser'], password=os.environ['dbpasswd'], database=os.environ['dbname'],port=5431)
    except Exception as e:
        logger.error("ERROR: Unexpected error: Could not connect to Postgres instance.")
        logger.error(e)
        sys.exit()

    logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

    cur = conn.cursor()
    f = open(download_path, "r")
    try:
        cur.copy_expert("COPY {} FROM stdin DELIMITER \',\' CSV header;".format(table_name), f)
        cur.execute("commit;")
    except Exception as e:
        ex_type, ex_value, ex_traceback = sys.exc_info()
        trace_back = traceback.extract_tb(ex_traceback)
        stack_trace = list()
        for trace in trace_back:
            stack_trace.append("File : %s , Line : %d, Func.Name : %s, Message : %s" % (trace[0], trace[1], trace[2], trace[3]))
        print("Exception type : %s " % ex_type.__name__ )
        print("Stack trace : %s" %stack_trace)
        return ("Exception message : %s" %ex_value)
    conn.close()
    print("DB connection closed.")
    return "File loaded into RDS" 

  
@app.route('/result')
def fetchBatch():
    try:
        conn = psycopg2.connect(host=os.environ['dbhost'], user=os.environ['dbuser'], password=os.environ['dbpasswd'], database=os.environ['dbname'],port=5431)
    except Exception as e:
        logger.error("ERROR: Unexpected error: Could not connect to Postgres instance.")
        logger.error(e)
        sys.exit()

    logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

    cur = conn.cursor()
    cur.execute("SELECT Distinct t2.purshase_date as PurchaseDate ,t1.customer_id as CustomerID , t1.customer_city CustomerCity, t3.product_id as ProductID, t3.product_category as ProductCategory FROM customers_table t1 JOIN parchase_history_table t2 ON t2.customer_id = t1.customer_id , parchase_history_table t4 Join products_table t3 on t4.product_id = t3.product_id WHERE t2.purshase_date >  date_trunc('month', CURRENT_DATE) - INTERVAL '20 year' order by (t1.customer_city)")
    s = "<table>"  
    columns=["<th>"+x[0]+"</th>" for x in cur.description]  
    s+="<tr>" +''.join(columns)+"</tr>"
    for row in cur:    
        s = s + "<tr>"    
        for x in row:    
            s = s + "<td>" + str(x) + "</td>"    
        s = s + "</tr>" 
    conn.close()
    print("DB connection closed.")
    return "<html><head><style>table, th, td { border: 1px solid red;}</style></head><body><h5>Query Result</h5><br>" + s + "</body></html>" 