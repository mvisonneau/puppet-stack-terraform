#
# AWS Provisioning
#
variable "access_key" {}
variable "secret_key" {}
variable "ssh_key" {}
variable "owner" {}
variable "vdc" {}

variable "domain" {
  default = "example.lan"
}

variable "region" {
  default = "eu-central-1"
}

variable "azs" {
  default = {
    "eu-west-1"    = "a,b,c"
    "eu-central-1" = "a,b"
  }
}

variable "amis_ubuntu_140404" {
  default = {
    "eu-west-1"    = "ami-f95ef58a"
    "eu-central-1" = "ami-7e9b7c11"
  }
}

#
# Instances Sizes
#
variable "instance_jump" {
  default = "t2.nano"
}

variable "instance_puppetca" {
  default = "t2.medium"
}

variable "instance_puppetdb" {
  default = "t2.medium"
}

#
# RDS Configuration
#
variable "rds_instance" {
  default = "db.t2.medium"
}

variable "rds_version" {
  default = "9.4.5"
}

variable "rds_size" {
  default = "10"
}

#
# Networking
#
variable "vpc_cidr" {
  default = "172.16.8.0/25"
}

variable "subnet_bits" {
  default = "3"
}

#
# Puppet Configuration
#
variable "git_provider" {}
variable "git_api_token" {}
variable "git_hostname" {}
variable "git_user" {}
variable "git_project" {}

variable "git_port" {
  default = "22"
}

variable "r10k_version" {
  default = "1.5.1"
}

variable "puppet_agent_version" {
  default = "1.4.1-1trusty"
}

variable "pm_gms_version" {
  default = "1.0.1"
}

variable "pm_r10k_version" {
  default = "3.2.0"
}

variable "pm_lvm_version" {
  default = "0.7.0"
}

variable "hiera_file_path" {
  default = "/etc/puppetlabs/code/environments/production/site/profiles/files/puppet/server/hiera.yaml"
}

variable "site_file_path" {
  default = "/etc/puppetlabs/code/environments/production/site.pp"
}
