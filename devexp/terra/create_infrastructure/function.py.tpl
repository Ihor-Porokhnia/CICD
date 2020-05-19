import boto3, json
app_name="${APPNAME}"
env_id="${ENVID}"
s3_bucket="${S3BUCKET}"
s3_prefix="${S3PREFIX}"
s3_prefix_b="${S3PREFIXB}"
s3_prefix_f="${S3PREFIXF}"
def lambda_handler(event, context):
    if event['operation'] == "scale":
     responce = scale_env()
     return responce
    if app_ready() != "Ready":
     return ({'result' : 'error', 'type' : 'call', 'params' : 'enviroment is busy'})
    if event['operation'] == "descale":
     responce = descale_env()
     return responce 
    if event['operation'] == "set":
     responce = set_version(event)
     return responce
    if event['operation'] == "create":
     responce = create_version(event)
     return responce    
    else:
     return ({'result' : 'error', 'type' : 'call', 'params' : 'no such operation'})
     

def create_version(event):
 if exist_version(event) != "ERROR" :
  return ({'result' : 'error', 'type' : 'create', 'params' : 'version already exists'})
 client_ebs = boto3.client('elasticbeanstalk')
 client_s3 = boto3.client('s3')
 try:
   response = client_s3.copy_object(
    Bucket=s3_bucket,
    CopySource=s3_bucket+s3_prefix+event['app_version'],
    Key=s3_prefix_b+event['app_version'],
    )
 except Exception as e:  
  exception_type = e.__class__.__name__
  exception_message = str(e)
  return ({'result' : 'error', 'type' : 's3 copy', 'params' : exception_message})

 try:
  response = client_ebs.create_application_version(
    ApplicationName=app_name,
    AutoCreateApplication=False,
    Description='created by lambda',
    Process=True,
    SourceBundle={
        'S3Bucket': s3_bucket,
        'S3Key': s3_prefix_b+event['app_version'],
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
def descale_env():
 client_ebs = boto3.client('elasticbeanstalk')
 responce = client_ebs.update_environment(
  EnvironmentId=env_id,
  OptionSettings=[
   {
            'Namespace': 'aws:autoscaling:asg',
            'OptionName': 'MinSize',
            'Value': '0',
        },
   {
            'Namespace': 'aws:autoscaling:asg',
            'OptionName': 'MaxSize',
            'Value': '0',
        },   
   ],)
  
 return responce['Status']    
def scale_env():
 client_ebs = boto3.client('elasticbeanstalk')
 responce = client_ebs.update_environment(
  EnvironmentId=env_id,
  OptionSettings=[
   {
            'Namespace': 'aws:autoscaling:asg',
            'OptionName': 'MinSize',
            'Value': '1',
        },
   {
            'Namespace': 'aws:autoscaling:asg',
            'OptionName': 'MaxSize',
            'Value': '2',
        },   
   ],)
   
 return responce['Status']    