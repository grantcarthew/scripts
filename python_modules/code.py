import random
import re
from typing import List

invalid_character_check = re.compile('.*[0o1il].*')


def new_alphanumeric_code(length: int = 4) -> str:
    """Generates an alphanumeric code of the set length that will not include 0o1il."""
    valid_letters = 'ABCDEFGHJKMNPQRSTUVWXYZ'
    valid_numbers = '23456789'
    valid_number_pool = ''.join(random.choice(valid_numbers).lower()
                                for _ in range(len(valid_letters)))
    code_first_letter = random.choice(valid_letters).lower()
    new_code = code_first_letter + \
        ''.join(random.choice(valid_number_pool + valid_letters).lower()
                for _ in range(length - 1))
    return new_code


def verify_alphanumeric_code(code: str, length: int = 4) -> bool:
    """Returns True if the code is alphanumeric, the correct length, and there are no invalid characters."""
    # TODO Log the error
    if not code:
        return False
    if not code.isalnum():
        return False
    if not len(code) == length:
        return False
    if invalid_character_check.match(code.lower()):
        return False
    return True


def get_code_conflict_data(code: str) -> List:
    """Queries existing data sources for any matching codes, returns either the data or None."""
    # TODO Conflict check

    return list()
