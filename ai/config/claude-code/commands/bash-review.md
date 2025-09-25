---
argument-hint: <script-file> or <script-content>
description: Comprehensive security-focused review of Bash scripts
allowed-tools: Read, Bash(shellcheck:*)
---

# Bash Script Security Review

Perform a comprehensive security-focused review of the Bash script: $ARGUMENTS

## Review Focus Areas

### Security Analysis

- Command injection vulnerabilities
- Path traversal risks
- Privilege escalation potential
- Input sanitization and validation
- Unsafe variable expansions
- Temporary file handling security

### Code Quality

- ShellCheck compliance and warnings
- POSIX compatibility where applicable
- Error handling and exit codes
- Logging and debugging practices
- Variable scoping and naming

### Best Practices

- Proper quoting and escaping
- Safe file operations
- Signal handling
- Resource cleanup
- Performance optimizations

## Review Process

1. **Static Analysis**: Run shellcheck if script file is provided
2. **Manual Security Review**: Examine code for security vulnerabilities
3. **Best Practices Check**: Validate against shell scripting standards
4. **Actionable Recommendations**: Provide specific fixes with code examples

## Output Requirements

- **Critical Issues**: Security vulnerabilities requiring immediate attention
- **Warnings**: Potential problems that should be addressed
- **Improvements**: Suggestions for better practices
- **Fixed Code**: Provide corrected code snippets for issues found

Focus on **actionable feedback** with specific examples. Prioritize security concerns over style preferences.
