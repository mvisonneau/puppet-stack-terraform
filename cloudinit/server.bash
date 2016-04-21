#!/bin/bash
set -e
set -x

export PATH=$PATH:/opt/puppetlabs/bin

cat > /tmp/bootstrap_r10k.pp <<END
# Deploy the key of the host onto the git manager
git_deploy_key { "puppetserver_public:\$${::fqdn}":
  ensure       => present,
  path         => '/etc/ssh/ssh_host_rsa_key.pub',
  token        => '${git_api_token}',
  project_name => '${git_control_project}',
  server_url   => 'https://${git_hostname}',
  provider     => '${git_provider}',
  require      => File['/root/.ssh/id_rsa.pub'],
}

git_deploy_key { "puppetserver_private:\$${::fqdn}":
  ensure       => present,
  path         => '/etc/ssh/ssh_host_rsa_key.pub',
  token        => '${git_api_token}',
  project_name => '${git_encryption_project}',
  server_url   => 'https://${git_hostname}',
  provider     => '${git_provider}',
  require      => File['/root/.ssh/id_rsa.pub'],
}

# Configure R10K
class { '::r10k':
  version => '${r10k_version}',
  sources => {
    'control' => {
      'remote'  => 'ssh://${git_user}@${git_hostname}:${git_port}/${git_control_project}.git',
      'basedir' => "\$${::settings::codedir}/environments",
      'prefix'  => false,
    },
    'encryption' => {
      'remote'  => 'ssh://${git_user}@${git_hostname}:${git_port}/${git_encryption_project}.git',
      'basedir' => "\$${::settings::codedir}/environments",
      'prefix'  => false,
    }
  },
  manage_modulepath => false,
  require           => [
    Git_deploy_key['puppetserver_public:\$${::fqdn}'],
    Git_deploy_key['puppetserver_private:\$${::fqdn}'],
  ],
}

# FS Management
class { '::lvm':
  manage_pkg => true,
} ->

lvm::volume { 'ssllv':
  ensure => present,
  vg     => 'sslvg',
  pv     => '/dev/xvdb',
  fstype => 'ext4',
} ->

mount { '/dev/sslvg/ssllv':
  ensure => mounted,
  name   => '/etc/puppetlabs/puppet/ssl',
  atboot => true,
  device => '/dev/sslvg/ssllv',
  dump   => '1',
  fstype => 'ext4',
  pass   => '2',
}

# Link the root user keys to the host ones
file { '/root/.ssh/id_rsa':
  ensure => '/etc/ssh/ssh_host_rsa_key',
}

file { '/root/.ssh/id_rsa.pub':
  ensure => '/etc/ssh/ssh_host_rsa_key.pub',
}
END

# Install required modules
puppet module install abrader-gms -v ${pm_gms_version}
puppet module install zack-r10k -v ${pm_r10k_version}
puppet module install puppetlabs-lvm -v ${pm_lvm_version}

# Kickstart R10K and manage encrypted EBS using LVM
puppet apply /tmp/bootstrap_r10k.pp
rm -f /tmp/bootstrap_r10k.pp
ssh-keyscan -p${git_port} -H ${git_hostname} > /root/.ssh/known_hosts 2>/dev/null
r10k deploy environment ${encryption_environment} --puppetfile -v
r10k deploy environment ${control_environment} --puppetfile -v

# Kickstart the CA
puppet apply --environment=${encryption_environment} /etc/puppetlabs/code/environments/${encryption_environment}/${site_file_path} 2>/dev/null

# Configure HIERA
cp /etc/puppetlabs/code/environments/${control_environment}/${hiera_file_path} /etc/puppetlabs/code/hiera.yaml

service puppetserver restart
