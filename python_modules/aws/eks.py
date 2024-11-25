import logging
import boto3
import rich
from datetime import datetime, timedelta
from awscli.customizations.eks.get_token import (
    TOKEN_EXPIRATION_MINS, STSClientFactory, TokenGenerator)
from botocore import session
from python_modules import cache
from python_modules.aws.region import getAvailableRegionList
from python_modules.terminal.error import reportError
from rich.console import Console
from rich.progress import track
console = Console()


def getEksAuthenticationToken(clusterName: str, roleArn: str = None) -> dict:
    """ Returns the EKS Kubernetes REST API authentication token. """
    log.debug('clusterName: %s roleArn: %s', clusterName, roleArn)
    cacheKey = f'{clusterName}-eksAuthenticationToken'
    cacheData = cache.getAwsValue(cacheKey)
    if cacheData:
        return cacheData
    # with console.status('Getting EKS Authentication Token...'):
    tokenExpiration = datetime.utcnow() + timedelta(minutes=TOKEN_EXPIRATION_MINS)
    expirationTime = tokenExpiration.strftime('%Y-%m-%dT%H:%M:%SZ')
    eksClientFactory = STSClientFactory(session.Session())
    eksStsClient = eksClientFactory.get_sts_client(role_arn=roleArn)
    token = TokenGenerator(eksStsClient).get_token(clusterName)
    fullToken = {
        "kind": "ExecCredential",
        "apiVersion": "client.authentication.k8s.io/v1alpha1",
        "spec": {},
        "status": {
                "expirationTimestamp": expirationTime,
                "token": token
        }
    }
    cache.setAwsValue(cacheKey, fullToken, TOKEN_EXPIRATION_MINS * 1000)
    return fullToken


def getEksAdminRole() -> dict:
    """ Returns the EKS administrative IAM role. """
    log.debug('')
    cacheKey = '<add-role-name-here>'
    cacheData = cache.getAwsValue(cacheKey)
    if cacheData:
        return cacheData

    eksAdminRole = None
    iamClient = boto3.client('iam')

    if not eksAdminRole:
        roles = iamClient.list_roles()
        for role in roles['Roles']:
            roleItem = role['RoleName'].lower()
            if ('eks' in roleItem or 'kubernetes' in roleItem) and 'admin' in roleItem:
                eksAdminRole = role

    if eksAdminRole:
        cache.setAwsValue(cacheKey, eksAdminRole, cache.ONE_MONTH)
        return eksAdminRole

    raise Exception("""
    EKS administrative role unknown.
    Could not find either 'EKS-Admin' or 'Kubernetes-Admin' roles.
    Searched all IAM roles for 'EKS' or 'Kubernetes' with 'Admin' and found none.
    Unable to proceed.
    """)


def getEksClusterListByRegion(region: str) -> dict:
    """ Queries AWS for the EKS clusters in one region only """
    log.debug(f'region: {region}')
    eksClient = boto3.client('eks', region_name=region)
    clusters = eksClient.list_clusters()['clusters']
    clusterDetailList = list()
    for cluster in clusters:
        clusterDetail = eksClient.describe_cluster(name=cluster)['cluster']
        clusterDetail['region'] = region
        clusterDetailList.append(clusterDetail)
    return clusterDetailList


def getClusterNodegroups(clusterName: str, region: str) -> list:
    """ Queries AWS for the EKS nodegroup(s) belonging to a cluster """
    log.debug(f'clusterName: {clusterName}')
    log.debug(f'region: {region}')
    eksClient = boto3.client('eks', region_name=region)
    nodegroups = eksClient.list_nodegroups(clusterName=clusterName)['nodegroups']
    nodegroupDetailList = list()
    for nodegroup in nodegroups:
        nodegroupDetail = eksClient.describe_nodegroup(clusterName=clusterName, nodegroupName=nodegroup)['nodegroup']
        nodegroupDetailList.append(nodegroupDetail)
    return nodegroupDetailList


