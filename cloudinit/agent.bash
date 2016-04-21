#!/bin/bash
set -e
set -x

export PATH=$PATH:/opt/puppetlabs/bin

puppet agent -t --server=${server_name} --environment=${control_environment}
