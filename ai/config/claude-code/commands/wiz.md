# Wiz CLI Reference Guide

## Overview

Wiz CLI v0.99.0-d13f80a - Command line interface for Wiz Cloud Security Platform

```
Usage:
  wizcli [flags]
  wizcli [command]
```

## Authentication

### Service Account Setup
Your Wiz CLI is authenticated using service account environment variables:
- `WIZ_CLIENT_ID` - Service account client ID
- `WIZ_CLIENT_SECRET` - Service account secret

### Auth Commands
```bash
# Check authentication status (print token info)
wizcli auth --print-token

# Authenticate with service account credentials
wizcli auth --id <client-id> --secret <client-secret>

# Use device code flow
wizcli auth --use-device-code --no-browser

# Logout
wizcli auth --logout
```

## Global Flags

Available for all commands:
```
--log string     File path for debug logs
-C, --no-color   Disable color output
-S, --no-style   Disable stylized output
-T, --no-telemetry   Disable telemetry
```

## Scanning Commands

### Directory Scanning

```bash
wizcli dir scan --path /path/to/directory [flags]
```

**Key Flags:**
- `--path string` - Directory to scan (required)
- `--format string` - Output format [human, json, sarif] (default: human)
- `--output file-outputs` - Output to file with format specification
- `--policy strings` - Scan policies to use
- `--policy-hits-only` - Only show policy failures
- `--secrets` - Scan for secrets (default: true)
- `--sensitive-data` - Find PII, PCI, PHI data (default: false)
- `--file-hashes-scan` - Enable malware scanning
- `--show-vulnerability-details` - Show CVE details from NVD
- `--show-secret-snippets` - Show secret snippets
- `--no-publish` - Don't publish results to portal
- `--project string` - Scoped project UUID
- `--tag tags` - Tag the scan (KEY or KEY=VALUE)
- `--timeout string` - Operation timeout (default: 1h)

**SBOM Generation:**
- `--sbom-format string` - [cyclonedx-xml, cyclonedx-json, spdx-txt, spdx-json]
- `--sbom-output-file string` - Local file path for SBOM

### Infrastructure as Code (IAC) Scanning

```bash
wizcli iac scan --path /path/to/iac [flags]
```

**Key Flags:**
- `--path stringArray` - Files/directories to scan (required)
- `--types strings` - Specific IAC types to scan
- `--secrets` - Scan for secrets (default: true)
- `--discovered-resources` - Discover cloud resources (Terraform only)
- `--ignore-comments` - Enable ignore comments (default: false)
- `--legacy-secret-scanner` - Use legacy secret scanner

**Supported IAC Types:**
- Ansible
- AzureResourceManager
- Bicep
- CloudFormation
- Dockerfile
- GitHubActions
- GoogleCloudDeploymentManager
- Kubernetes
- Terraform

**CloudFormation Specific:**
- `--expand-cloudformation-intrinsics` - Expand intrinsic functions
- `--keep-false-conditions` - Keep resources with false conditions
- `--max-cloudformation-intrinsics-depth int` - Max depth (default: 32)
- `--parameter-files strings` - External parameter files

**Performance Tuning:**
- `--dir-traversal-workers int` - Directory traversal workers (default: 14)
- `--rule-evaluation-workers int` - Rule evaluation workers (default: 16)
- `--max-file-size byte-size` - Max file size to scan (default: 64MiB)

### IAC Parsing

```bash
wizcli iac parse --path /path/to/iac --output-folder /output [flags]
```

**Key Flags:**
- `--path stringArray` - Files/folders to parse (required)
- `--output-folder string` - Output folder (required)
- `--matcher-type string` - Parse specific type (default: Terraform)

### Docker Image Scanning

```bash
wizcli docker scan --image <image-name> [flags]
```

**Key Flags:**
- `--image string` - Image name with tag/digest or path to .tar file (required)
- `--dockerfile string` - Dockerfile used to build the image
- `--driver string` - Driver for scanning [extract] (default: extract)
- `--group-by string` - Output grouping [default, layer, resource] (default: default)
- `--secrets` - Scan for secrets (default: true)
- `--sensitive-data` - Find sensitive data (default: false)
- `--file-hashes-scan` - Enable malware scanning

**Docker Tagging:**
```bash
wizcli docker tag --image <image-name> [flags]
```
- `--digest string` - Image digest for exported images
- `--driver string` - Driver used (default: extract)

### Virtual Machine Scanning

```bash
wizcli vm scan --id <vm-id> [flags]
```

**Key Flags:**
- `--id string` - Virtual machine ID (required)
- `--timeout string` - Operation timeout (default: 6h)

### VM Image Scanning

```bash
wizcli vm-image scan --id <image-id> --region <region> --subscriptionId <subscription> [flags]
```

**Key Flags:**
- `--id string` - Image ID (required)
- `--region string` - Image region (required)
- `--subscriptionId string` - AWS account/GCP project/Azure subscription (required)
- `--connectorName string` - Connector name
- `--timeout string` - Operation timeout (default: 6h)

## Output and Reporting

### Output Formats
- `human` - Human-readable format (default)
- `json` - JSON format
- `sarif` - SARIF format for security tools

### File Output Format
```bash
--output file-path[,file-format[,policy-hits-only[,group-by[,include-audit-policy-hits]]]]
```

**File Format Options:**
- `csv-zip` - Compressed CSV
- `human` - Human-readable
- `json` - JSON format
- `sarif` - SARIF format

### Grouping Options
- `default` - Default grouping
- `layer` - Group by layer (Docker images)
- `resource` - Group by resource

## Policy Management

### Policy Flags
- `--policy strings` - Multiple policies can be specified
- `--policy-hits-only` - Show only policy violations
- `--include-audit-policy-hits` - Include audit policies with block policies
- `--show-grace-period-findings` - Show grace period findings

### Filtering and Analytics
- `--apply-filter-to-analytics` - Apply console filter to all results

## Common Patterns

### Basic Directory Scan
```bash
wizcli dir scan --path . --format json --output results.json
```

### IAC Scan with Specific Policies
```bash
wizcli iac scan --path ./terraform --types Terraform --policy "Custom Policy" --policy-hits-only
```

### Docker Image Scan with SBOM
```bash
wizcli docker scan --image nginx:latest --sbom-format cyclonedx-json --sbom-output-file nginx-sbom.json
```

### Comprehensive Directory Scan
```bash
wizcli dir scan \
  --path . \
  --secrets \
  --sensitive-data \
  --show-vulnerability-details \
  --format json \
  --output scan-results.json,json,false,default,true
```

## Configuration

### Wiz Configuration File
Use `--wiz-configuration-file string` to specify custom configuration files for scan behavior.

### Application Environment
Use `--application strings` to define code application environment affecting ignore rules.

### Tagging
```bash
# Simple tag
--tag environment=production

# Multiple tags
--tag environment=production --tag team=security --tag scan-type
```

## Documentation

Official documentation: https://docs.wiz.io/wiz-docs/docs/wiz-cli-overview

## Version Information

Current version: v0.99.0-d13f80a (built 2025-09-14T11:44:00Z)

```bash
wizcli version
```