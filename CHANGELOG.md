# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2022-10-02
### Added
- `ghidra_uri_override` variable for installing custom Ghidra versions.
- `ghidra_extract_folder_name`- tmp variable
- `ghidra_zip_file_name` - tmp variable


## [1.0.0] - 2022-09-10
### Added
- AWS Support
    - EC2 Instance
    - EBS Volume
    - Ingress Security Group
    - VPC (optional)
    - Subnets (optional)
    - DNS Zone (optional)
    - DNS record (optional)
- Linode Support
    - Linode Instance
    - Linode Volume
    - Ingress Firewall
- Ghidra Support
    - Versions 10.0+
    - Custom install path
    - Custom repo path
    - server.conf Configuration