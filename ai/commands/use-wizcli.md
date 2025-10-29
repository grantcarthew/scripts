---
argument-hint: [scan-type] [path] [additional-options]
description: Intelligent security scanning with Wiz CLI for comprehensive vulnerability assessment
allowed-tools: Bash(wizcli:*)
model: claude-3-5-haiku-20241022
---

# Wiz Security Scanner

Perform security scanning with Wiz CLI: $ARGUMENTS

## Scan Types

`dir` `iac` `docker` `vm` `vm-image`

## Common Flags

- `--secrets` Scan for exposed secrets (API keys, credentials)
- `--policy-hits-only` Show only policy violations
- `--show-vulnerability-details` Include CVE information
- `--sensitive-data` Detect PII/PCI/PHI data
- `--file-hashes-scan` Enable malware detection
- `--discovered-resources` Show discovered resources (IAC)
- `--format json` Machine-readable output
- `--output FILE` Save results to file
- `--sbom-format FORMAT` Generate SBOM (cyclonedx-json, spdx-json)

## Command Examples

### Directory Scan

```bash
wizcli dir scan --path . --secrets --policy-hits-only
wizcli dir scan --path /code --secrets --sensitive-data --show-vulnerability-details
```

### Infrastructure as Code

```bash
wizcli iac scan --path ./terraform --secrets --policy-hits-only
wizcli iac scan --path . --secrets --discovered-resources --format json
```

### Docker/Container

```bash
wizcli docker scan --image nginx:latest --sbom-format cyclonedx-json
wizcli docker scan --image myapp:1.0 --secrets --sensitive-data --file-hashes-scan
```

### VM Scanning

```bash
wizcli vm scan --vm-id <vm-identifier>
wizcli vm-image scan --image-id <image-identifier>
```

## Authentication

```bash
wizcli auth --print-token  # check status
wizcli auth --id $WIZ_CLIENT_ID --secret $WIZ_CLIENT_SECRET  # authenticate
```

## Auto-Detection

If scan type not specified, detect based on target:
- Docker images: Contains `:` or registry name
- IAC files: `.tf`, `.yml`, `.yaml`, `.json` with CloudFormation/K8s/Terraform
- Default: Directory scan

## Usage Notes

Execute appropriate scan based on arguments. Always include `--secrets` for security scans. Prioritize findings: critical vulnerabilities, exposed secrets, policy violations, compliance gaps. Provide actionable remediation guidance.
