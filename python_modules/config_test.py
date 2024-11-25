import os
import json
import mock
import unittest
from unittest import TestCase
from config import save_config, load_config

class TestConfig(TestCase):

    @mock.patch('config.open', mock.mock_open())
    @mock.patch('config.input')
    def test_load_config(self, mock_input):
        # arrange
        mock_input.return_value = 'John'
        mock_config = {
            'first_name': 'John',
            'last_name': 'Doe',
            'email_prefix': 'johndoe',
            'github_repo_path': '/path/to/repos'
        }
        config_file = os.path.expanduser('~/.config/bin_config')
        with open(config_file, 'w') as config_file:
            json.dump(mock_config, config_file)
        # act
        result = load_config()
        # assert
        self.assertEqual(mock_config, result)
        self.assertFalse(os.path.exists(config_file))

    @mock.patch('config.open', mock.mock_open())
    def test_save_config(self):
        # arrange
        mock_config = {
            'first_name': 'John',
            'last_name': 'Doe',
            'email_prefix': 'johndoe',
            'github_repo_path': '/path/to/repos'
        }
        config_file = os.path.expanduser('~/.config/bin_config')
        # act
        save_config(mock_config)
        # assert
        handle = open(config_file)
        self.assertEqual(json.load(handle), mock_config)
        handle.close()

if __name__ == '__main__':
    unittest.main()
