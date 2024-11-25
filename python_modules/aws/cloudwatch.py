from botocore.exceptions import ClientError
from datetime import date, datetime
from pathlib import Path
from rich import print as rprint
from rich.progress import Progress, track
from typing import List, Dict, Any, Optional
import awswrangler as wr
import boto3
import pandas as pd

from python_modules.aws.profile import get_profile_list

_progress: Progress = None

def _get_progress_bar() -> Progress:
    global _progress
    if _progress is None:
        _progress = Progress(transient=True)
    return _progress


def get_log_stream_data(profile_name: str, log_group_name: str) -> pd.DataFrame:
    """
    Retrieve log stream data for a specific AWS profile and log group.

    Args:
        profile_name: AWS profile name
        log_group_name: AWS log group name

    Returns:
        DataFrame containing log stream data.
    """
    session = boto3.Session(profile_name=profile_name, region_name='ap-southeast-2')
    cw_logs = session.client('logs')
    log_streams: List[Dict[str, Any]] = []
    next_token = None

    while True:
        args = {'logGroupName': log_group_name}
        if next_token:
            args['nextToken'] = next_token
        response = cw_logs.describe_log_streams(**args)

        for stream in response['logStreams']:
            stream['account'] = profile_name
            log_streams.append(stream)

        next_token = response.get('nextToken')
        if not next_token:
            break

    return pd.DataFrame(log_streams)


def get_log_group_data_by_account(profile_name: str, ignore_empty: bool = False) -> pd.DataFrame:
    """
    Retrieve log group data for a specific AWS profile.

    Args:
        profile_name: AWS profile name

    Returns:
        DataFrame containing log group data.
    """
    session = boto3.Session(profile_name=profile_name, region_name='ap-southeast-2')
    cw_logs = session.client('logs')
    log_group_data: List[Dict[str, Any]] = []
    next_token = None

    while True:
        args = {}
        if next_token:
            args['nextToken'] = next_token
        response = cw_logs.describe_log_groups(**args)

        for log_group in response['logGroups']:
            if ignore_empty and log_group['storedBytes'] == 0:
                continue
            log_group['account'] = profile_name
            log_group_data.append(log_group)

        next_token = response.get('nextToken')
        if not next_token:
            break

    df = pd.DataFrame(log_group_data)
    df['creationTime'] = pd.to_datetime(df['creationTime'], unit='ms')
    df['storedGigaBytes'] = (df['storedBytes'] / (1024 ** 3)).round(2)
    return df[['account', 'storedBytes', 'storedGigaBytes', 'creationTime', 'logGroupName', 'retentionInDays', 'metricFilterCount', 'arn']]


def get_log_group_data_all_accounts(ignore_empty: bool = False) -> pd.DataFrame:
    profile_list = get_profile_list()

    with _get_progress_bar() as progress:
        task_name = "Log Group"
        profile_count = len(profile_list)
        task = progress.add_task(f"{task_name} [{profile_count}]", total=profile_count)

        dfs = []
        for profile in profile_list:
            progress.update(task, description=f'{task_name} ({profile})', refresh=True)
            try:
                dfs.append(get_log_group_data_by_account(profile, ignore_empty=ignore_empty))
                progress.console.print(f'[cyan]{task_name}:[/] {profile} [green]✔[/]')
            except Exception as err:
                progress.console.print(f'[red]{task_name}:[/] {profile} [red]✖[/]')
                progress.console.print(f'[red]{err}[/]')
            progress.update(task, advance=1)

    return pd.concat(dfs).sort_values(by=['account', 'storedBytes'], ascending=[True, False])


def get_destination_data_by_account(profile_name: str) -> pd.DataFrame:
    """
    Retrieve log destination data for a specific AWS profile.

    Args:
        profile_name: AWS profile name

    Returns:
        DataFrame containing log destination data.
    """
    session = boto3.Session(profile_name=profile_name, region_name='ap-southeast-2')
    cw_logs = session.client('logs')
    destinations: List[Dict[str, Any]] = []
    next_token = None

    while True:
        args = {}
        if next_token:
            args['nextToken'] = next_token
        response = cw_logs.describe_destinations(**args)

        for dest in response['destinations']:
            dest['account'] = profile_name
            destinations.append(dest)

        next_token = response.get('nextToken')
        if not next_token:
            break

    return pd.DataFrame(destinations)


def get_destination_data_all_accounts() -> pd.DataFrame:
    """
    Get log destination data for all AWS profiles.

    Returns:
        DataFrame containing log destination data for all accounts.
    """
    profile_list = get_profile_list()
    dfs = [get_destination_data_by_account(profile) for profile in track(profile_list, transient=True)]
    return pd.concat(dfs)


def export_logs_single_profile(path: Path, profile_name: str, start_date: Optional[str] = None, end_date: Optional[str] = None, file_format: Optional[str] = 'csv') -> pd.DataFrame:
    """
    Export AWS CloudWatch logs for a single profile.

    Args:
        profile_name: AWS profile name
        start_date: Query start date in ISO format (yy-mm-dd)
        end_date: Query end date in ISO format (yy-mm-dd)

    Returns:
        DataFrame containing the queried logs.
    """
    if start_date is None:
        start_date = date.today().strftime('%Y-%m-%d')
    if end_date is None:
        end_date = date.today().strftime('%Y-%m-%d')

    session = boto3.Session(profile_name=profile_name, region_name='ap-southeast-2')
    log_group_df = get_log_group_data_by_account(profile_name, ignore_empty=True)
    log_groups = log_group_df['logGroupName'].to_list()

    with _get_progress_bar() as progress:
        task_name = "Log Group Data"
        total_log_groups = len(log_groups)
        task = progress.add_task(f"{task_name} [{profile_name}][{total_log_groups}]", total=total_log_groups)

        query_str = 'fields @timestamp, @message, @log | sort @timestamp desc'
        logs = []

        for log_group in log_groups:
            progress.update(task, description=f'{task_name} ({log_group})')
            try:
                df = wr.cloudwatch.read_logs(
                    query=query_str,
                    log_group_names=[log_group],
                    start_time=pd.Timestamp(start_date),
                    end_time=pd.Timestamp(end_date),
                    limit=10000,
                    boto3_session=session
                )
                rows = 0
                if not df.empty:
                    rows = df.shape[0]
                    df.drop('ptr', axis=1, inplace=True)
                    export_path = Path.joinpath(path, log_group.replace('/','_'))
                    if file_format == 'csv':
                        df.to_csv(f'{export_path}.csv', index=False)
                    else:
                        df.to_parquet(f'{export_path}.parquet', index=False)
                progress.console.print(f'[cyan]{task_name}:[/] {log_group} [cyan]Rows: {rows}[/] [green]✔[/]')
            except Exception as err:
                progress.console.print(f'[red]{task_name}:[/] {log_group} [red]✖[/]')
                progress.console.print(f'[red]{err}[/]')


            progress.update(task, advance=1)

        progress.update(task, completed=True)


def export_logs_all_profiles(path: Path, start_date: Optional[str] = None, end_date: Optional[str] = None, file_format: Optional[str] = 'csv') -> pd.DataFrame:
    """
    Export AWS CloudWatch logs across all profiles.

    Args:
        start_date: Query start date in ISO format (yy-mm-dd)
        end_date: Query end date in ISO format (yy-mm-dd)

    Returns:
        DataFrame containing the queried logs for all profiles.
    """
    profile_list = get_profile_list()

    with _get_progress_bar() as progress:
        profile_count = len(profile_list)
        task_name = "Log Data for Account"
        task = progress.add_task(f"{task_name} ({profile_count})", total=profile_count)

        for profile in profile_list:
            progress.update(task, description=f'{task_name} ({profile})', refresh=True)
            logs = export_logs_single_profile(path, profile, start_date, end_date)
            progress.console.print(f'[cyan]{task_name}:[/] {profile} [green]✔[/]')
            progress.update(task, advance=1)

        progress.update(task, completed=True)
