from typing import List
import boto3
import botocore


def get_profile_list() -> List[str]:
    """
    Get a list of available AWS profiles.

    Returns:
        A sorted list of profile names.
    """
    session = boto3.session.Session()
    aws_profiles = session.available_profiles

    return sorted(aws_profiles)


def get_profile_config(profile_name: str) -> dict:
    """
    Get the configuration details for a specified AWS profile.

    Args:
        profile_name: The name of the AWS profile to get the configuration for.

    Returns:
        A dictionary containing the configuration details of the specified profile.
    """
    session = botocore.session.Session(profile=profile_name)
    return session.get_scoped_config()