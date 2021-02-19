variable "tags" {
  type = map(string)
}

variable "env" {
  type = map(string)
}
variable "dns_domain" {}
variable "subnet_ids" {type = list(string)}

variable "pfc_sg_nonprd" {
  type = list(string)
  default = [
    "10.25.236.204/32",
    "10.25.236.167/32"
  ]
}

variable "pfc_sg_prd" {
  type = list(string)
  default = [
    "10.25.236.166/32"
  ]
}

variable "nova_sg_prd" {
  default = ["10.99.0.0/19"]
}

variable "nova_sg_nonprd" {
  default = ["10.37.0.0/20"]
}


