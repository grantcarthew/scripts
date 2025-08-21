# Project Specification: {{PROJECT_NAME}}

## Overview

{{PROJECT_OVERVIEW}}

## Functional Requirements

The system MUST:

- Accept a CSV file via a command-line argument
- Parse the 'email' and 'date_joined' columns from the CSV
- Generate a JSON report containing a list of users
- Print the location of the saved report to the console upon completion

## Constraints & Non-Functional Requirements

- Language/Platform: e.g., Python 3.10+
- Dependencies: e.g., Must use the 'pandas' library. Must NOT use any external APIs.
- Performance: e.g., Must process a 50MB CSV file in under 15 seconds.
- Code Style: e.g., All code must be formatted with 'black' and adhere to PEP 8.
- Error Handling: e.g., If the input file is not found, the script must exit gracefully with a clear error message.

## Supporting Information

- Anything the agent needs to implement the solution

## Deliverables & Acceptance Criteria

- Primary Deliverable: A single, executable Python script named script_name.py.
- Supporting Files: A requirements.txt file listing all necessary dependencies.
- Acceptance Criteria: The project is considered complete when the script can be run successfully against a sample CSV file and produces a valid JSON output file that matches the specified format.

## Execution Environment

You are running in the following environment:

- Operating System: {{OPERATING_SYSTEM}}
- Terminal: {{TERMINAL_TYPE}}
- Package Manager: {{PACKAGE_MANAGER}}

### CLI Tools Available

Following is the list of extra command-line tools available for you to use:

```txt
{{CLI_TOOLS}}
```
