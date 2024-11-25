from typing import List

import boto3
import pandas as pd
from datetime import date
from python_modules.aws.profile import get_profile_list


def get_cost_data_by_account(profile_name: str, start_date: date, end_date: date) -> pd.DataFrame:
    """
    Get the daily cost data for a specific AWS account within a given date range.

    Args:
        profile_name: The name of the AWS profile.
        start_date: The start date of the date range.
        end_date: The end date of the date range.

    Returns:
        A pandas DataFrame containing the cost data.
    """
    session = boto3.Session(profile_name=profile_name, region_name='ap-southeast-2')
    ce = session.client('ce')

    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start_date.isoformat(),
            'End': end_date.isoformat()
        },
        Granularity='DAILY',
        Metrics=['UnblendedCost']
    )

    flattened_data = [{
        'account': profile_name,
        'date': pd.to_datetime(daily_data['TimePeriod']['Start']),
        'amount': round(float(daily_data['Total']['UnblendedCost']['Amount']), 2),
        'currency': str(daily_data['Total']['UnblendedCost']['Unit'])
    } for daily_data in response['ResultsByTime']]

    return pd.DataFrame(flattened_data)

def get_cost_data_all_accounts(start_date: date, end_date: date) -> pd.DataFrame:
    """
    Get the daily cost data for all available AWS accounts within a given date range.

    Args:
        start_date: The start date of the date range.
        end_date: The end date of the date range.

    Returns:
        A pandas DataFrame containing the cost data for all accounts.
    """
    cost_dataframes = [get_cost_data_by_account(profile, start_date, end_date) for profile in get_profile_list()]
    return pd.concat(cost_dataframes)
