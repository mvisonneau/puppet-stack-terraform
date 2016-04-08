#!/bin/bash
set -e
set -x

export PATH=$PATH:/opt/puppetlabs/bin

cat > /tmp/bootstrap_r10k.pp <<END
# Deploy the key of the host onto the git manager
git_deploy_key { 'add_deploy_key_to_puppet_control':
  ensure       => present,
  name         => "puppetserver: \$${::fqdn}",
  path         => '/etc/ssh/ssh_host_rsa_key.pub',
  token        => '${git_api_token}',
  project_name => '${git_project}',
  server_url   => 'https://${git_hostname}',
  provider     => '${git_provider}',
}

# Configure R10K
class { '::r10k':
  version           => '${r10k_version}',
  sources           => {
    'puppet'        => {
      'remote'      => 'ssh://${git_user}@${git_hostname}:${git_port}/${git_project}.git',
      'basedir'     => "\$${::settings::codedir}/environments",
      'prefix'      => false,
    }
  },
  manage_modulepath => false,
  require           => Git_deploy_key['add_deploy_key_to_puppet_control'],
}

# Sorry about this one, need to figure out how to remove it from here, guessing
# that not everyone need this..
package { 'figlet':
  ensure => present,
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

# Link the root user key to the host one
file { '/root/.ssh/id_rsa':
  ensure => '/etc/ssh/ssh_host_rsa_key',
}
END

# Install required modules
puppet module install abrader-gms -v ${pm_gms_version}
puppet module install zack-r10k -v ${pm_r10k_version}
puppet module install puppetlabs-lvm -v ${pm_lvm_version}

# Bootstrap R10K
puppet apply /tmp/bootstrap_r10k.pp
rm -f /tmp/bootstrap_r10k.pp
ssh-keyscan -p${git_port} -H ${git_hostname} > /root/.ssh/known_hosts 2>/dev/null
r10k deploy environment production --puppetfile -v
cp ${hiera_file_path} /etc/puppetlabs/code/hiera.yaml
puppet apply ${site_file_path} 2>/dev/null || /bin/true
