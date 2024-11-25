from botocore.exceptions import NoCredentialsError, InvalidConfigError
from rich import print as rprint
import boto3

def chech_auth() -> bool:
    valid = False
    try:
        sts = boto3.client('sts')
        sts.get_caller_identity()
        valid = True
    except NoCredentialsError:
        pass
    except InvalidConfigError as err:
        if 'sso_role_name' not in str(err):
            rprint(str(err))

    if (not valid):
        rprint('\n[orange1]Please authenticate to an AWS Account[/]\n')
    return valid