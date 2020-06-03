import boto3, json, os, time
from io import BytesIO
import zipfile
app_name=os.environ['APPNAME']
env_id=os.environ['ENVID']
s3_bucket=os.environ['S3BUCKET']
s3_prefix=os.environ['S3PREFIX']
s3_prefix_b=os.environ['S3PREFIXB']
s3_prefix_f=os.environ['S3PREFIXF']
s3_prefix_p=os.environ['S3PREFIXP']
clfront_id=os.environ['CLFRONTID']

def lambda_handler(event, context): 
    
    if event['operation'] == "set":
     response = unzip_version(event)
     return response
    if event['operation'] == "copy":
     response = copy_version(event)
     return response
    if event['operation'] == "clear":
     response = clear_folder(event)
     return response
    if event['operation'] == "invalidate":
     response = invalidate_cdn(event)
     return response 
    else:
     return ({'result' : 'error', 'type' : 'call', 'params' : 'no such operation'})
     
 
def unzip_version(event):
  s3_resource = boto3.resource('s3')
  zip_obj = s3_resource.Object(bucket_name=s3_bucket, key=s3_prefix_f+event['app_version'])
  buffer = BytesIO(zip_obj.get()["Body"].read())
  z = zipfile.ZipFile(buffer)
  for filename in z.namelist():
    file_info = z.getinfo(filename)
    try:
      response = s3_resource.meta.client.upload_fileobj(
                        z.open(filename),
                        Bucket=s3_bucket,
                        Key=s3_prefix_p+filename,
                    )
    except Exception as e:
     return e
  return "done"
def copy_version(event):
 s3_resource = boto3.resource('s3')
 s3_resource.Object(s3_bucket, s3_prefix_f+event['app_version']).copy_from(CopySource=s3_bucket+"/"+s3_prefix+event['app_version'])
 return "done"
    
def clear_folder(event):
 s3 = boto3.resource('s3')
 bucket = s3.Bucket(s3_bucket)
 bucket.objects.filter(Prefix=s3_prefix_p).delete()
 return "Done"
 
def invalidate_cdn(event):
 client = boto3.client('cloudfront')
 response = client.create_invalidation(
    DistributionId=clfront_id,
    InvalidationBatch={
        'Paths': {
            'Quantity': 1,
            'Items': [
                '/',
            ]
        },
        'CallerReference': str(time.time())
    }
    )
 return str(response)   