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
     return ("LOL")
    except Exception as e:
     exception_type = e.__class__.__name__
     exception_message = str(e)
     api_exception_obj = {
      "isError": True,
      "type": exception_type,
      "message": exception_message
     }
     #api_exception_json = json.dumps(api_exception_obj)
     return("ERR")