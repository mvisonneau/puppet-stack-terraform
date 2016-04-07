# Provision a Puppet stack on AWS using Terraform

## Overview

This terraform configuration can bootstrap the resources needed to host the following components of Puppet:
- Puppet CA
- Puppet DB

## Puppet CA

We provision a single instance that can host a Puppet CA. This instance is running behind an ELB.
We plan to rewrite and extend this configuration soon.

## Puppet DB

We provision a cluster of instances ( 1 per AZ available in the region ) that can host a Puppet DB service. Thoses instances are reached behind an ELB and uses an PostgreSQL RDS database for the shared storage.

## Usage

- Configure `terraform.tf` file according the `terraform.tf.example`
- `terraform apply`
