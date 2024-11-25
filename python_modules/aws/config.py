import json
import configparser

def parse_config(file_path):
    """
    Gets the contents from the supplied AWS config file and returns an object
    with all the profiles that included a env_alias property.

    Args:
        file_path: File path for the AWS config file.

    Returns:
        A sorted list of profiles that included a env_alias property.
    """
    config = configparser.ConfigParser()
    config.read(file_path)

    aws_profiles = {}

    for section in config.sections():
        # Check if 'env_alias' exists in the section
        if config.has_option(section, 'env_alias'):
            env_alias = config.get(section, 'env_alias')
            sso_account_id = config.get(section, 'sso_account_id')

            # Add the entry to the dictionary
            aws_profiles[env_alias] = sso_account_id

    return aws_profiles