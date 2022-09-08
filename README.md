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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_eip.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_volume_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.ssm-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_route53_zone.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where this infrastructure will be deployed to. | `string` | `"us-east-2"` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR range to use for the private network. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_create_dns_record"></a> [create\_dns\_record](#input\_create\_dns\_record) | Whether or not to create a dedicated DNS record for the server. If you have a pre-existing Route53 zone in your AWS account, you can set this to true to create a dedicated record on it. | `bool` | `false` | no |
| <a name="input_create_networking"></a> [create\_networking](#input\_create\_networking) | Whether or not to create the networking infrastructure for the instance. If you already have a preexsting VPC for the instance(s) to go in, set this to false. | `bool` | `true` | no |
| <a name="input_dns_record_name"></a> [dns\_record\_name](#input\_dns\_record\_name) | The name of the DNS record to create on the zone looked up by `dns_zone_name`. | `string` | `"ghidra"` | no |
| <a name="input_dns_record_ttl"></a> [dns\_record\_ttl](#input\_dns\_record\_ttl) | The time-to-live for the DNS record | `number` | `60` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The DNS zone to lookup in the account to provision the DNS record on. | `string` | `"replaceme"` | no |
| <a name="input_ghidra_install_path"></a> [ghidra\_install\_path](#input\_ghidra\_install\_path) | The filesystem path where the Ghidra server will be installed to. This path should be an absolute path from the filesystem root. | `string` | `"/opt/ghidra/"` | no |
| <a name="input_ghidra_name"></a> [ghidra\_name](#input\_ghidra\_name) | The name that will be given to the Ghidra instance(s) as a prefix 'ghidra\_name-version | `string` | `"ghidra"` | no |
| <a name="input_ghidra_repo_path"></a> [ghidra\_repo\_path](#input\_ghidra\_repo\_path) | The filesystem path where any Ghidra repositories will be stored. This path should be an absolute path from the filesystem root. It is recommended to not have this be a subfolder under the Ghidra installation. | `string` | `"/mnt/repos/"` | no |
| <a name="input_ghidra_server_config"></a> [ghidra\_server\_config](#input\_ghidra\_server\_config) | Config for the server. If you're setting any of the server.conf variables, don't set this. | `string` | `null` | no |
| <a name="input_ghidra_server_log_level"></a> [ghidra\_server\_log\_level](#input\_ghidra\_server\_log\_level) | The log level of the Ghidra server. Should be one of: FATAL, ERROR, WARN, STATUS, INFO, DEBUG. **(server.conf variable)** | `string` | `"INFO"` | no |
| <a name="input_ghidra_uri"></a> [ghidra\_uri](#input\_ghidra\_uri) | The URI that will be used along with the ghidra\_version as a source endpoint for the Ghidra install files. You probably won't need to change this. | `string` | `"https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_"` | no |
| <a name="input_ghidra_version"></a> [ghidra\_version](#input\_ghidra\_version) | The version of Ghidra to install. | `string` | `"10.0"` | no |
| <a name="input_ghidra_version_map"></a> [ghidra\_version\_map](#input\_ghidra\_version\_map) | Map of ghidra versions to release dates to properly look up the release URI. You probably won't need to change this unless a new version of Ghidra comes out. | `map(any)` | <pre>{<br>  "10.0": "20210621",<br>  "10.0.1": "20210708",<br>  "10.0.2": "20210804",<br>  "10.0.3": "20210908",<br>  "10.0.4": "20210928",<br>  "10.1": "20211210",<br>  "10.1.5": "20220726"<br>}</pre> | no |
| <a name="input_initial_java_heap_size"></a> [initial\_java\_heap\_size](#input\_initial\_java\_heap\_size) | Initial Java Heap Size (in MB). **(server.conf variable)** | `number` | `396` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type to use. | `string` | `"t3.micro"` | no |
| <a name="input_max_java_heap_size"></a> [max\_java\_heap\_size](#input\_max\_java\_heap\_size) | Maximum Java Heap Size (in MB). **(server.conf variable)** | `number` | `768` | no |
| <a name="input_repo_device_name"></a> [repo\_device\_name](#input\_repo\_device\_name) | The name given to the repo EBS volume in Linux. | `string` | `"/dev/sdb"` | no |
| <a name="input_repo_volume_size"></a> [repo\_volume\_size](#input\_repo\_volume\_size) | The size (in GBs) of the EBS volume that will house your Ghidra repos. | `number` | `30` | no |
| <a name="input_repo_volume_type"></a> [repo\_volume\_type](#input\_repo\_volume\_type) | The EBS volume type that will house your Ghidra repos. | `string` | `"gp2"` | no |
| <a name="input_s3_backup"></a> [s3\_backup](#input\_s3\_backup) | Whether or not to create an S3 backup. | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket that will be used for the Ghidra database backups. Since S3 buckets have to be globally unique, it's recommended not to set this and let the module generate it for you. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to lookup and place the instance(s) in. Do no set this if create\_networking is true. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to lookup and place the instance(s) in. Do not set this if create\_networking is true. | `string` | `null` | no |

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
    - Ghidra extensions support
    - Add more Terratest cases
    - Support for Windows (bootstrap script and image support)
- AWS
    - Spot instance support
    - Block device backup support
- Linode
    - DNS Support
    - Block device backup support