# == class: profile::monitoring
#
# Manages different monitoring services
#
# === Parameters
#
# $manage_promehteus      Manage prometheus instances
#
class profile::monitoring (
  Boolean $manage_prometheus = false,
)
{
  if $manage_prometheus {
    class { '::profile::monitoring::prometheus': }
  }
}
