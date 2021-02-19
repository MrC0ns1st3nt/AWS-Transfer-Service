################################################################################
# Terraform Backend Initialization
terraform {
  required_version = "0.14.2"
}
################################################################################

# SFTP server
module "sftp-server-only" {
  source                     = "../../../modules/sftp-server-only"
  env                        = var.env
  tags                       = var.tags
  dns_domain                 = var.internal_dns_domain
  subnet_ids                 = var.subnet_ids
}



module "sftp-server-user-readwrite" {
  for_each                    = var.readwrite
  source                      = "../../../modules/sftp-server-user"
  sftp-server-id              = "${module.sftp-server-only.sftp-transfer-server-id}"
  env                         = var.env
  tags                        = var.tags
  s3-bucket                   = var.s3_bucket
  s3-bucketlist               = var.s3-bucketlist
  s3-actions                  = var.readwrite_actions
  sftp-user                   = each.value
  s3-prefix                   = var.user_prefix
  sftp-home-directory         = ""
}





