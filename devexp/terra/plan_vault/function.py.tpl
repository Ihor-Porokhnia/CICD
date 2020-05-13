import boto3, json

def lambda_handler(event, context):
    app_name="${APPNAME}"
    env_id="${ENVID}"
    client = boto3.client('elasticbeanstalk')
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
     return ({'result' : 'error', 'params' : exception_message})