import boto3, json
app_name="${APPNAME}"
env_id="${ENVID}"
s3_bucket="${S3BUCKET}"
s3_prefix="${S3PREFIX}"
def lambda_handler(event, context):
    
    if app_ready() != "Ready":
     return ({'result' : 'error', 'type' : 'call', 'params' : 'enviroment is busy'})
    if event['operation'] == "set":
     responce = set_version(event)
     return responce
    if event['operation'] == "create":
     responce = create_version(event)
     return responce
    if event['operation'] == "update":
     responce = create_version(event)
     if responce["result"] == "error":
      return responce
     responce = set_version(event)
     return responce
    else:
     return ({'result' : 'error', 'type' : 'call', 'params' : 'no such operation'})
     

def create_version(event):
 if exist_version(event) != "ERROR" :
  return ({'result' : 'error', 'type' : 'create', 'params' : 'version already exists'})
 client_ebs = boto3.client('elasticbeanstalk')
 client_s3 = boto3.client('s3')
 try:
  response = client_ebs.create_application_version(
    ApplicationName=app_name,
    AutoCreateApplication=False,
    Description='created by lambda',
    Process=True,
    SourceBundle={
        'S3Bucket': s3_bucket,
        'S3Key': s3_prefix+event['app_version'],
    },
    VersionLabel=event['app_version'],
    )
  
  return ({'result' : 'ok', 'type' : 'create', 'params' : event['app_version']})
 except Exception as e:  
  exception_type = e.__class__.__name__
  exception_message = str(e)
  return ({'result' : 'error', 'type' : 'create', 'params' : exception_message})

def set_version(event):
 if exist_version(event) == "ERROR" :
  return ({'result' : 'error', 'type' : 'set', 'params' : 'no such version'})
 client_ebs = boto3.client('elasticbeanstalk')
 if exist_version(event) != "PROCESSED":
  return ({'result' : 'error', 'type' : 'set', 'params' : 'version is processing'})
 try:
  response = client_ebs.update_environment(
      ApplicationName=app_name,
      EnvironmentId=env_id,
      VersionLabel=event['app_version']
   )
  return ({'result' : 'ok', 'type' : 'set', 'params' : event['app_version']})
 except Exception as e:  
  exception_type = e.__class__.__name__
  exception_message = str(e)
  return ({'result' : 'error', 'type' : 'set', 'params' : exception_message})
  
def exist_version(event):
 client_ebs = boto3.client('elasticbeanstalk')
 response = client_ebs.describe_application_versions(
    ApplicationName=app_name,)
 #print(response)   
 for req in response["ApplicationVersions"] :
  if req["VersionLabel"] == event['app_version'] :
   return(req["Status"])
  
 return "ERROR"
 
def app_ready():
 client_ebs = boto3.client('elasticbeanstalk')
 response = client_ebs.describe_environment_health(
    EnvironmentId=env_id,
    AttributeNames=[
        'Status',
    ])
 return response['Status']