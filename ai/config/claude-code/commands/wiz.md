---
argument-hint: [scan-type] [path] [additional-options]
description: Intelligent security scanning with Wiz CLI for comprehensive vulnerability assessment
allowed-tools: Bash(wizcli:*)
---

# Wiz Security Scanner

Perform intelligent security scanning with Wiz CLI: $ARGUMENTS

## Smart Scan Detection

Automatically determine the best scan type based on arguments:

### Scan Types

- **dir [path]** - Directory/code security scan
- **iac [path]** - Infrastructure as Code security scan
- **docker [image]** - Container image security scan
- **vm [vm-id]** - Virtual machine security scan
- **vm-image [image-id]** - VM image security scan

### Auto-Detection Rules

If no scan type specified:

1. **Docker Images**: Detect image names (contains `:` or common registries)
2. **IAC Files**: Detect Terraform (.tf), CloudFormation (.yml/.json), Kubernetes (.yaml)
3. **Code Directories**: Default to directory scan for source code
4. **Current Directory**: Scan current directory if no path specified

## Common Scan Workflows

### Quick Security Assessment

```bash
# Scan current directory with secrets detection
wizcli dir scan --path . --secrets --policy-hits-only

# Scan Docker image with SBOM generation
wizcli docker scan --image $1 --sbom-format cyclonedx-json

# Validate Infrastructure as Code
wizcli iac scan --path $1 --secrets --policy-hits-only
```

### Comprehensive Analysis

```bash
# Full directory scan with all features
wizcli dir scan --path $1 --secrets --sensitive-data --show-vulnerability-details

# IAC scan with resource discovery
wizcli iac scan --path $1 --secrets --discovered-resources

# Container scan with detailed output
wizcli docker scan --image $1 --secrets --sensitive-data --file-hashes-scan
```

## Scan Execution Strategy

Based on the provided arguments, execute the most appropriate scan:

1. **Argument Analysis**: Determine scan type and target
2. **Security Configuration**: Apply security-focused scan options
3. **Output Optimization**: Format results for actionable insights
4. **Risk Prioritization**: Highlight critical security findings

## Key Security Features

### Essential Flags

- `--secrets` - Always scan for exposed secrets
- `--policy-hits-only` - Focus on policy violations
- `--show-vulnerability-details` - Get CVE information
- `--sensitive-data` - Detect PII/PCI/PHI data
- `--file-hashes-scan` - Enable malware detection

### Output Options

- `--format json` - Machine-readable results
- `--output results.json` - Save to file
- `--sbom-format cyclonedx-json` - Generate SBOM

## Usage Examples

```bash
# Quick security scan
/wiz dir .

# Docker image security scan
/wiz docker nginx:latest

# Infrastructure scan
/wiz iac ./terraform

# Comprehensive analysis
/wiz dir . --comprehensive
```

## Authentication Check

Ensure authentication is configured:

```bash
# Check auth status
wizcli auth --print-token

# Authenticate if needed
wizcli auth --id $WIZ_CLIENT_ID --secret $WIZ_CLIENT_SECRET
```

## Result Analysis

Provide prioritized security findings:

- **Critical Vulnerabilities**: Immediate attention required
- **Secret Exposures**: Credentials and keys found
- **Policy Violations**: Security policy failures
- **Compliance Issues**: Regulatory compliance gaps

Focus on actionable security insights and remediation guidance.
