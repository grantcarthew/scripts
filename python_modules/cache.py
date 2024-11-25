"""

This module provides a persistent cache for any type of object or value.
It is built on top of the Python shelve module.

For the functions with AWS in their name, the cache is dependent on
the AWS Account keys assigned in the terminal.

Usage:

    from python_modules import cache

    key = 'name of a thing'
    value = 'something expensive to get'
    ttl = 86400000 # 1 day in milliseconds

    cache.setValue(key, value, ttl) # 'None'
    cache.getValue(key) # 'None' if key does not exist
    cache.removeValue(key) # 'True' if the value existed, otherwise 'False'

    cache.clearCache()

    # AWS Account ID functions
    cache.setAwsValue(key, value, ttl)
    cache.getAwsValue(key)
    cache.removeAwsValue(key)

Notes:

    getValue:
    - Will return the original value for a cache hit.
    - Will return 'None' for a cache miss.
    - Will return 'None' if the value is past the TTL.

    setValue:
    - Assigns the value to the supplied key in the cache.
    - The TTL value is in milliseconds.
    - The default TTL value is 0.
    - Any TTL value less than 1 will never expire.
    - Returns 'None'

    removeValue:
    - Deletes the key from the cache if it exists.
    - Returns 'True' if the key did exist.
    - Returns 'False' if the key did not exist.

AWS Cache:

    To be able to cache values whilst authenticated to different
    AWS Accounts, the setAwsValue, getAwsValue, and removeAwsValue
    functions prefix the AWS Account ID onto the key prior to working
    with the cache. For example, this prevents the key of 'EKS-Admin'
    from being overwritten if you use different AWS Account Keys.

"""
import os
import shelve
import rich
from threading import Lock
from pathlib import Path
from datetime import datetime, timedelta
from python_modules.definitions import BIN_CACHE_PATH, BIN_VERSION
# from python_modules.aws.account import getAwsAccountId
import logging
log = logging.getLogger('python_modules')
mutex = Lock()

ONE_MINUTE = 60000
FIVE_MINUTES = 300000
TEN_MINUTES = 600000
TWENTY_MINUTES = 1200000
THIRTY_MINUTES = 1800000
FOURTY_MINUTES = 2400000
FIFTY_MINUTES = 3000000
ONE_HOUR = 3600000
ONE_DAY = 86400000
ONE_WEEK = 604800000
TWO_WEEKS = 1209600000
ONE_MONTH = 2629800000
SIX_MONTHS = 15778800000
ONE_YEAR = 31557600000


def __assertCache(cache):
    """ Ensures the cache is in a stable state """
    log.debug('Entered function')
    key = 'python_modulesVersion'
    if key in cache:
        cacheData = cache[key]
        if cacheData == BIN_VERSION:
            return

    log.debug('Cache key %s does not match BIN_VERSION:%s', key, BIN_VERSION)
    for keyToClear in list(cache.keys()):
        del cache[keyToClear]
    cache[key] = BIN_VERSION


def setValue(key: str, value: any, ttl: int = 0) -> None:
    """ Sets an AWS Account cache key to a value with optional TTL """
    log.debug('key: %s value: %s ttl: %s', key, value, ttl)
    with mutex, shelve.open(BIN_CACHE_PATH) as cache:
        __assertCache(cache)
        if ttl > 0:
            ttl = datetime.now() + timedelta(milliseconds=ttl)
        cache[key] = {
            'value': value,
            'ttl': ttl
        }
    return None


def getValue(key: str) -> any:
    """ Gets a value from the AWS Account cache if exists and within TTL """
    log.debug('key: %s', key)
    with mutex, shelve.open(BIN_CACHE_PATH) as cache:
        __assertCache(cache)
        if key not in cache:
            log.debug('key not in cache: %s', key)
            return None
        cacheData = cache[key]

    if type(cacheData['ttl']) != datetime:
        log.debug('Value ttl not set: %s', key)
        return cacheData['value']
    if cacheData['ttl'] < datetime.now():
        log.debug('Value ttl has expired: %s', key)
        return None
    log.debug('Cache hit: %s', key)
    return cacheData['value']


def removeValue(key: str) -> bool:
    """ Deletes a specific key from the cache """
    with mutex, shelve.open(BIN_CACHE_PATH) as cache:
        __assertCache(cache)
        if key:
            del cache[key]
            return True
    return False


def clearCache() -> None:
    """ Deletes all keys from the cache including AWS Account related keys """
    with mutex, shelve.open(BIN_CACHE_PATH) as cache:
        for key in list(cache.keys()):
            del cache[key]
    return None


# def setAwsValue(key: str, value: any, ttl: int = 0) -> None:
#     """ Sets an AWS Account cache key to a value with optional TTL """
#     awsAccountId = getAwsAccountId()
#     newKey = f'{awsAccountId}-{key}'
#     return setValue(newKey, value, ttl)


# def getAwsValue(key: str) -> any:
#     """ Gets a value from the AWS Account cache if exists and within TTL """
#     awsAccountId = getAwsAccountId()
#     newKey = f'{awsAccountId}-{key}'
#     return getValue(newKey)


# def removeAwsValue(key: str) -> dict:
#     """ Deletes a specific key from the AWS Account cache """
#     awsAccountId = getAwsAccountId()
#     newKey = f'{awsAccountId}-{key}'
#     return removeValue(newKey)
