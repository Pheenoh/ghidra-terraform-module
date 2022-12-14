# Ghidra Terraform Module

This Terraform module will install Ghidra on an AWS EC2 instance or Linode instance.

## Prequisites

### General 
- [Terraform](https://www.terraform.io/downloads)

### AWS
- [AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) the AWS CLI

### Linode
- [Linode Account](https://login.linode.com/signup)
- [Linode CLI](https://www.linode.com/docs/products/tools/cli/get-started/)


## Deploying the module

```bash
# Clone the module down
git clone https://github.com/zsrtp/ghidra-terraform-module
cd ghidra-terraform-module

# Initialize and apply Terraform
terraform init
terraform apply
```

# Examples

See [here](./examples/aws/README.md) for examples. To use them, reate a `terraform.tfvars` file in the directory root first before running `terraform init` and `terraform apply`.


# General Module Information
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_linode"></a> [linode](#requirement\_linode) | 1.29.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws"></a> [aws](#module\_aws) | ./modules/aws | n/a |
| <a name="module_linode"></a> [linode](#module\_linode) | ./modules/linode | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cidr_block"></a> [aws\_cidr\_block](#input\_aws\_cidr\_block) | The CIDR range to use for the private network. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_aws_create_dns_record"></a> [aws\_create\_dns\_record](#input\_aws\_create\_dns\_record) | Whether or not to create a dedicated DNS record for the server. If you have a pre-existing Route53 zone in your AWS account, you can set this to true to create a dedicated record on it. | `bool` | `false` | no |
| <a name="input_aws_create_networking"></a> [aws\_create\_networking](#input\_aws\_create\_networking) | Whether or not to create the networking infrastructure for the instance. If you already have a preexsting VPC for the instance(s) to go in, set this to false. | `bool` | `true` | no |
| <a name="input_aws_dns_record_name"></a> [aws\_dns\_record\_name](#input\_aws\_dns\_record\_name) | The name of the DNS record to create on the zone looked up by `dns_zone_name`. | `string` | `"ghidra"` | no |
| <a name="input_aws_dns_record_ttl"></a> [aws\_dns\_record\_ttl](#input\_aws\_dns\_record\_ttl) | The time-to-live for the DNS record | `number` | `60` | no |
| <a name="input_aws_dns_zone_name"></a> [aws\_dns\_zone\_name](#input\_aws\_dns\_zone\_name) | The DNS zone to lookup in the account to provision the DNS record on. | `string` | `"replaceme"` | no |
| <a name="input_aws_instance_type"></a> [aws\_instance\_type](#input\_aws\_instance\_type) | The EC2 instance type to use. | `string` | `"t3.micro"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where this infrastructure will be deployed to. | `string` | `"us-east-2"` | no |
| <a name="input_aws_s3_backup"></a> [aws\_s3\_backup](#input\_aws\_s3\_backup) | Whether or not to create an S3 backup. | `bool` | `false` | no |
| <a name="input_aws_s3_bucket_name"></a> [aws\_s3\_bucket\_name](#input\_aws\_s3\_bucket\_name) | The name of the S3 bucket that will be used for the Ghidra database backups. Since S3 buckets have to be globally unique, it's recommended not to set this and let the module generate it for you. | `string` | `null` | no |
| <a name="input_aws_subnet_id"></a> [aws\_subnet\_id](#input\_aws\_subnet\_id) | The ID of the subnet to lookup and place the instance(s) in. Do no set this if create\_networking is true. | `string` | `null` | no |
| <a name="input_aws_volume_type"></a> [aws\_volume\_type](#input\_aws\_volume\_type) | The EBS volume type that will house your Ghidra repos. | `string` | `"gp2"` | no |
| <a name="input_aws_vpc_id"></a> [aws\_vpc\_id](#input\_aws\_vpc\_id) | The ID of the VPC to lookup and place the instance(s) in. Do not set this if create\_networking is true. | `string` | `null` | no |
| <a name="input_ghidra_install_path"></a> [ghidra\_install\_path](#input\_ghidra\_install\_path) | The filesystem path where the Ghidra server will be installed to. This path should be an absolute path from the filesystem root. | `string` | `"/opt/ghidra/"` | no |
| <a name="input_ghidra_name"></a> [ghidra\_name](#input\_ghidra\_name) | The name that will be given to the Ghidra instance(s) as a prefix 'ghidra\_name-version | `string` | `"ghidra"` | no |
| <a name="input_ghidra_repo_path"></a> [ghidra\_repo\_path](#input\_ghidra\_repo\_path) | The filesystem path where any Ghidra repositories will be stored. This path should be an absolute path from the filesystem root. It is recommended to not have this be a subfolder under the Ghidra installation. | `string` | `"/mnt/repos/"` | no |
| <a name="input_ghidra_server_config"></a> [ghidra\_server\_config](#input\_ghidra\_server\_config) | Config for the server. If you're setting any of the server.conf variables, don't set this. | `string` | `null` | no |
| <a name="input_ghidra_server_log_level"></a> [ghidra\_server\_log\_level](#input\_ghidra\_server\_log\_level) | The log level of the Ghidra server. Should be one of: FATAL, ERROR, WARN, STATUS, INFO, DEBUG. **(server.conf variable)** | `string` | `"INFO"` | no |
| <a name="input_ghidra_uri"></a> [ghidra\_uri](#input\_ghidra\_uri) | The URI that will be used along with the ghidra\_version as a source endpoint for the Ghidra install files. You probably won't need to change this. | `string` | `"https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_"` | no |
| <a name="input_ghidra_uri_override"></a> [ghidra\_uri\_override](#input\_ghidra\_uri\_override) | Use this to manually specify the download location of a compressed Ghidra archive. Only set this if you need to use a custom version of Ghidra. | `string` | `null` | no |
| <a name="input_ghidra_version"></a> [ghidra\_version](#input\_ghidra\_version) | The version of Ghidra to install. | `string` | `"10.0"` | no |
| <a name="input_ghidra_version_map"></a> [ghidra\_version\_map](#input\_ghidra\_version\_map) | Map of ghidra versions to release dates to properly look up the release URI. You probably won't need to change this unless a new version of Ghidra comes out. | `map(any)` | <pre>{<br>  "10.0": "20210621",<br>  "10.0.1": "20210708",<br>  "10.0.2": "20210804",<br>  "10.0.3": "20210908",<br>  "10.0.4": "20210928",<br>  "10.1": "20211210",<br>  "10.1.1": "20211221",<br>  "10.1.2": "20220125",<br>  "10.1.3": "20220421",<br>  "10.1.4": "20220519",<br>  "10.1.5": "20220726"<br>}</pre> | no |
| <a name="input_initial_java_heap_size"></a> [initial\_java\_heap\_size](#input\_initial\_java\_heap\_size) | Initial Java Heap Size (in MB). **(server.conf variable)** | `number` | `396` | no |
| <a name="input_linode_config_path"></a> [linode\_config\_path](#input\_linode\_config\_path) | Path to your local linode config file. | `string` | `"~/.config/linode-cli"` | no |
| <a name="input_linode_instance_type"></a> [linode\_instance\_type](#input\_linode\_instance\_type) | The Linode instance type to use. | `string` | `"g6-standard-1"` | no |
| <a name="input_linode_region"></a> [linode\_region](#input\_linode\_region) | The Linode region where this infrastructure will be deployed to. | `string` | `"us-east"` | no |
| <a name="input_linode_root_password"></a> [linode\_root\_password](#input\_linode\_root\_password) | The root password of the Linode instance. | `string` | `"replaceme"` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | API token to connect to your Linode tenant. | `string` | `"replaceme"` | no |
| <a name="input_max_java_heap_size"></a> [max\_java\_heap\_size](#input\_max\_java\_heap\_size) | Maximum Java Heap Size (in MB). **(server.conf variable)** | `number` | `768` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | The provider you're deploying to. Should be one of: aws. | `string` | `"aws"` | no |
| <a name="input_repo_device_name"></a> [repo\_device\_name](#input\_repo\_device\_name) | The name given to the repo volume in Linux. | `string` | `"/dev/sdb"` | no |
| <a name="input_repo_volume_size"></a> [repo\_volume\_size](#input\_repo\_volume\_size) | The size (in GBs) of the volume that will house your Ghidra repos. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ghidra_private_ip"></a> [ghidra\_private\_ip](#output\_ghidra\_private\_ip) | The private IP of the Ghidra instance. |
| <a name="output_ghidra_public_dns_name"></a> [ghidra\_public\_dns\_name](#output\_ghidra\_public\_dns\_name) | The public DNS name given to the EC2 instance. |
| <a name="output_ghidra_public_ip"></a> [ghidra\_public\_ip](#output\_ghidra\_public\_ip) | The private IP of the Ghidra instance. |
| <a name="output_ghidra_uri"></a> [ghidra\_uri](#output\_ghidra\_uri) | The Ghidra download URI. |
<!-- END_TF_DOCS -->

## To-Do

- All Platforms
    - Add more Terratest cases
    - Bring Ghidra locals block to top level
    - Auto lookup Ghidra archives using http data source
    - Support for Windows (bootstrap script and image support)
- AWS
    - Spot instance support
    - Block device backup support
- Linode
    - DNS Support
    - Block device backup support