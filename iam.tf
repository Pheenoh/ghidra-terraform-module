# Grab AWS account info
data "aws_caller_identity" "current" {}

# IAM role for the instance profile
resource "aws_iam_role" "ec2-role" {
  count = !var.use_spot ? 1 : 0
  name  = "${local.ghidra_instance_name}-role"
  path  = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

# IAM policy for the IAM role
data "aws_iam_policy" "ssm-policy" {
  name = "AmazonSSMManagedInstanceCore"
}

# SSM policy attachment
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.ec2-role[0].name
  policy_arn = data.aws_iam_policy.ssm-policy.arn
}

# IAM instance profile for launch template
resource "aws_iam_instance_profile" "default" {
  name = "${local.ghidra_instance_name}-instance-profile"
  role = aws_iam_role.ec2-role[0].name
}