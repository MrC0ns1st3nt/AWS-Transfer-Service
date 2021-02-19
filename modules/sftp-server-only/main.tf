terraform {
  backend "s3" {}
}

provider "aws" {
  region  = var.env.region
  version = "= 3.26.0"
}

#VPC Endpoint 

resource "aws_security_group" "transfer_security_group" {
  name                = "${var.env.name}-sg"
  description         = "Transfer Server security group"
  vpc_id              = var.env.vpc_id

  tags = {
    "Name" = "${var.env.name}-sg"
  }
}

resource "aws_security_group_rule" "allow_transfer_open" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.transfer_security_group.id
  description = "Allow connectivity to everyone"
}


resource "aws_vpc_endpoint" "transfer" {
  vpc_id                  = var.env.vpc_id
  service_name            = "com.amazonaws.${var.env.region}.transfer.server"
  vpc_endpoint_type       = "Interface"
  subnet_ids              = var.subnet_ids

  security_group_ids = [
    aws_security_group.transfer_security_group.id
  ] 

  tags = {
    "Name" = "${var.env.name}"
  }
}


# SFTP Server
resource "aws_iam_role" "sftp-iam-role" {
    name = "${var.env["name"]}-transfer-server-iam-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "sftp-iam-role-policy" {
    name = "${var.env["name"]}-transfer-server-iam-policy"
    role = aws_iam_role.sftp-iam-role.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "*"
        }
    ]
}
POLICY
}


resource "aws_transfer_server" "server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role = aws_iam_role.sftp-iam-role.arn
  endpoint_type = "VPC_ENDPOINT"
  endpoint_details {
    vpc_endpoint_id = aws_vpc_endpoint.transfer.id
  }
  
  tags = "${merge(map("hostname", "${var.env["name"]}"), var.tags)}"
}

data "aws_route53_zone" "selected" {
  name = var.dns_domain
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.env["name"]}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_vpc_endpoint.transfer.dns_entry[0]["dns_name"]]
  
}

