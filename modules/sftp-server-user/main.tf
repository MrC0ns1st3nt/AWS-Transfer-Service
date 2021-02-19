terraform {
  backend "s3" {}
}

# AWS Transfer USER resources
resource "aws_iam_role" "user-role" {
    name = "${var.env["name"]}-${var.sftp-user}-transfer-user-iam-role"

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

data "aws_iam_policy_document" "access_policy_template" {

  statement {
    sid = "RequiredforCyberDuck"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }

  statement {
    actions = formatlist("s3:%s", var.s3-actions)
   resources = formatlist("arn:aws:s3:::%s/*", var.s3-prefix)
  }

  statement {
    actions = [
      "s3:List*"
    ]
    resources = formatlist("arn:aws:s3:::%s", var.s3-bucketlist)
  }
}

resource "aws_iam_role_policy" "access-role-policy" {
  name                      = "${var.env["name"]}-${var.sftp-user}-transfer-user-iam-policy"
  role                      = aws_iam_role.user-role.id
  policy = data.aws_iam_policy_document.access_policy_template.json
}

resource "aws_transfer_user" "user" {
    server_id       = var.sftp-server-id
    user_name       = var.sftp-user
    role            = aws_iam_role.user-role.arn
    home_directory  = "/${var.s3-bucket}/${var.sftp-home-directory}"
    tags            = var.tags
}

resource "aws_secretsmanager_secret" "ssh-key-private" {
  name = "${var.env["name"]}-${var.sftp-user}-sftp-server-ssh-key"
  tags = var.tags
}

resource "null_resource" "execute" {
    depends_on = [aws_secretsmanager_secret.ssh-key-private]

    provisioner "local-exec" {
        command = "/bin/bash ${path.module}/ssh-key.sh ${var.env["name"]} ${var.sftp-server-id} ${var.sftp-user}"
    }
    
}