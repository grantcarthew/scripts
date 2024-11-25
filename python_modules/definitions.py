from os import path
from pathlib import Path

BIN_VERSION = '1.0.0'
BIN_CONFIG_HOME = Path.home() / '.config'
BIN_CONFIG_PATH = Path(BIN_CONFIG_HOME) / 'bin_config'
BIN_CACHE_PATH = Path(BIN_CONFIG_HOME) / 'cache'

BIN_CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
