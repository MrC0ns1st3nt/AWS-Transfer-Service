variable "internal_dns_domain" { default = "<dns_name>" }
variable "s3_bucket" { default = "<bucketname>" }
variable "s3-bucketlist" {
  type = list(string) 
  default = ["<bucketname>"]
}

variable "env" {
  type = map(string)
  default = {
    name = "<environment name>"
    region = "<AWS region>"
    vpc_id = "<VPC ID>"
  }
}

variable "tags" {
  type = map(string)
  default = {
    name             = "<environment name>"
    terraform        = "0.14.2"
    description      = "AWS Transfer Family service"
  }
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "<subnet1>",
    "<subnet2>"
  ]
}

// User list
variable "readwrite" {
  type              = map(string)
  default           = {
    user1           = "user1"
    user2           = "user2"
    user3           = "user3"
  }
}

variable "readwrite_actions" {
  type = list(string)
  default = [
    "GetObject",
    "GetObjectVersion",
    "PutObject"
  ]
}

// IAM Policy bucket permissions

variable "user_prefix" {
  type = list(string)
  default = [
    "<bucketname>/<prefix>/"
  ]
}







