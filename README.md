# Helm Parametrize Script

This script is designed to parametrize Helm chart values by reading configuration and secrets files from a specified directory. It encodes the content of these files if necessary and outputs them in a key-value format, suitable for use with Helm charts.

## Prerequisites

- Bash environment
- Perl installed (for inline editing of strings)

## Usage

The script expects two primary arguments: an environment identifier and a configuration file path.

```bash
./helm_parametrize.sh [environment] -f [config_path]
```

### Arguments

- `[environment]`: Environment identifier (e.g., "dev", "prod").
- `-f [config_path]`: Path to the configuration files. This is a required argument.

### Example

```bash
./helm_parametrize.sh dev -f /path/to/config
```

## Description

Here's a detailed breakdown of the script:

1. **Error Handling and Usage Message**: 
    - Exits immediately if any command has a non-zero status.
    - Prints a usage message and exits when invalid arguments are input or help is requested.

2. **Parsing Arguments**:
    - Parses command-line options, ensuring the environment identifier and configuration file path are provided.

3. **Validating Inputs**:
    - Checks if the environment identifier and configuration path are given and valid.

4. **Processing Files**:
    - Processes files within the given directory, differentiating between configurations and secrets.
    - Encodes secret files in base64. Replaces newlines with `\n` in config files.
    - Outputs each file's content in the format `type.key=content`.

5. **Executing for Configs and Secrets**:
    - Iterates over two types: "configs" and "secrets", processing files accordingly.
