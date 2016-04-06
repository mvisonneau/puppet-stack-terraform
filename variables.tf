variable "access_key" {}
variable "secret_key" {}
variable "ssh_key" {}
variable "owner" {}

variable "region" {
  default = "eu-central-1"
}

variable "azs" {
  default = {
    us-east-1 = "a,b,c,d,e"
    eu-central-1 = "a,b"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "amis_ubuntu_140404" {
  default = {
    eu-west-1    = "ami-f95ef58a"
    eu-central-1 = "ami-7e9b7c11"
  }
}

variable "vpc_cidr" {
  default = "172.16.8.0/25"
}

variable "subnet_bits" {
  default = "3"
}
