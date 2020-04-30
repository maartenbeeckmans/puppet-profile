# == Class: profile::base::repositories
#
# Manage epel repository
#
# === Dependencies
#
# - puppet-epel
#
# === Parameters
#
# $epel       Manage the epel repository
#
class profile::base::repositories (
  Boolean $epel = true,
)
{
  if $facts['os']['family'] == 'RedHat' and $epel {
    class { 'epel': }
    Yumrepo['epel'] -> Package <||>
  }
}
