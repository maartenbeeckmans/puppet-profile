# This class can be used to setup a bare minimum node
#
# @example when declaring the base class
#  class { '::profile::base': }
# 
class profile::base (
  Boolean $manage_accounts = false,
  Boolean $manage_firewall = false,
  Boolean $manage_fail2ban = false,
  Boolean $manage_packages = false,
  Boolean $manage_motd     = false,
  Boolean $manage_selinux  = false,
)
{
  if $manage_accounts {
    class { 'profile::base::accounts': }
  }

  if $manage_firewall {
    if $manage_fail2ban {
      class { 'profile::base::fail2ban': }
    }
    class { 'profile::firewall': }
  }

  if $manage_packages {
    class { 'profile::base::packages': }
  }

  if $manage_motd {
    class { 'profile::base::motd': }
  }

  if $manage_selinux {
    class { 'profile::base::selinux': }
  }
}
