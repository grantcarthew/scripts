import json
import os
import rich
from python_modules.definitions import BIN_CONFIG_PATH

def save_config(config):
    # Save the config as JSON to the config file
    with open(os.path.expanduser(BIN_CONFIG_PATH), 'w') as config_file:
        json.dump(config, config_file)

def load_config():
    # Load the config
    config_file = os.path.expanduser(BIN_CONFIG_PATH)
    if os.path.exists(config_file):
        with open(config_file) as config_file:
            config = json.load(config_file)
    else:
        config = {}

    # Check the schema of the config against the required properties
    required_properties = {
        'first_name': 'What is your first name? ',
        'last_name': 'What is your last name? ',
        'email_prefix': 'What is your email prefix ',
        'github_repo_path': 'Where is your local git repositories path? '
    }
    for prop, question in required_properties.items():
        if prop not in config:
            config[prop] = input(question)

    # Save the config if any property was missing
    save_config(config)
    return config

