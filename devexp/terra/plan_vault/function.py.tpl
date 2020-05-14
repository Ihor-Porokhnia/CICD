import boto3, json

def lambda_handler(event, context):
    app_name="${APPNAME}"
    env_id="${ENVID}"
    s3_bucket="${S3BUCKET}"
    s3_prefix="${S3PREFIX}"
    client = boto3.client('elasticbeanstalk')
    if event['operation'] == "set":
     try:
      response = client.update_environment(
          ApplicationName=app_name,
          EnvironmentId=env_id,
          VersionLabel=event['app_version']
       )
      return ({'result' : 'set', 'params' : event['app_version']})
     except Exception as e:
      exception_type = e.__class__.__name__
      exception_message = str(e)
      return ({'result' : 'set_error', 'params' : exception_message})


    if event['operation'] == "create":
     try:
      response = client.create_application_version(
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
      return ({'result' : 'create', 'params' : event['app_version']})
     except Exception as e:  
      exception_type = e.__class__.__name__
      exception_message = str(e)
      return ({'result' : 'create_error', 'params' : exception_message})

    if event['operation'] == "update":
     try:
      response1 = client.create_application_version(
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
      response = client.update_environment(
          ApplicationName=app_name,
          EnvironmentId=env_id,
          VersionLabel=event['app_version']
       )
      return ({'result' : 'update', 'params' : event['app_version']})
     except Exception as e:  
      exception_type = e.__class__.__name__
      exception_message = str(e)
      return ({'result' : 'update_error', 'params' : exception_message})  