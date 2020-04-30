# == Class: profile::base::puppet_agent
#
# Configures puppet agent
#
# === Dependencies
#
# - puppetlabs-puppet_agent
#
# === Parameters
#
# $package_version    Version of puppet agent
#
# $manage_repo        Manage the puppet repository
#
class profile::base::puppet_agent (
  $package_version = '6.14.0',
  $manage_repo = true,
)
{
  class {'::puppet_agent':
    package_version => $package_version,
    manage_repo     => $manage_repo,
    is_pe           => false,
  }
}
