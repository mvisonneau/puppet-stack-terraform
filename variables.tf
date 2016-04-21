#
# AWS Provisioning
#
variable "access_key" {}
variable "secret_key" {}
variable "ssh_key"    {}
variable "owner"      {}
variable "vdc"        {}
variable "domain"     { default = "example.lan" }
variable "region"     { default = "eu-central-1" }

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
variable "instance_jump"     { default = "t2.nano" }
variable "instance_puppetca" { default = "t2.medium" }
variable "instance_puppetdb" { default = "t2.medium" }

#
# RDS Configuration
#
variable "rds_instance"                { default = "db.t2.medium" }
variable "rds_version"                 { default = "9.4.5" }
variable "rds_size"                    { default = "10" }
variable "rds_name"                    { default = "puppetdb" }
variable "rds_username"                { default = "puppetdb" }
variable "rds_password"                { default = "puppetdb" }
variable "rds_multi_az"                { default = "false" }
variable "rds_maintenance_window"      { default = "Sun:01:00-Sun:04:00" }
variable "rds_backup_window"           { default = "11:00-11:45" }
variable "rds_backup_retention_period" { default = "3" }

#
# Networking
#
variable "vpc_cidr"    { default = "172.16.8.0/25" }
variable "subnet_bits" { default = "3" }

#
# Puppet Configuration
#
variable "git_provider"           {}
variable "git_api_token"          {}
variable "git_hostname"           {}
variable "git_user"               {}
variable "git_control_project"    {}
variable "git_encryption_project" {}

variable "git_port"               { default = "22" }
variable "r10k_version"           { default = "1.5.1" }
variable "hiera_eyaml_version"    { default = "2.1.0" }
variable "puppet_agent_version"   { default = "1.4.1-1trusty" }
variable "pm_gms_version"         { default = "1.0.1" }
variable "pm_r10k_version"        { default = "3.2.0" }
variable "pm_lvm_version"         { default = "0.7.0" }
variable "hiera_file_path"        { default = "site/profiles/files/puppet/server/hiera.yaml" }
variable "site_file_path"         { default = "site.pp" }
variable "encryption_environment" { default = "encryption" }
variable "control_environment"    { default = "production" }
