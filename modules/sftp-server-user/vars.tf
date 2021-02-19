variable "tags" {
  type = map(string)
}

variable "env" {
  type = map(string)
}

variable "s3-bucket" {}
variable "s3-bucketlist" { type = list(string)}
variable "sftp-user" { default = "test"}

variable "sftp-home-directory" {default = ""}

variable "sftp-server-id" {}

variable "s3-prefix" { type = list(string)}

variable "s3-actions" {
  type = list(string)
  default = [
    "GetObject",
    "GetObjectVersion"
  ]
  }
