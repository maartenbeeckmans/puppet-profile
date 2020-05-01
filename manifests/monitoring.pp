# == class: profile::monitoring
#
# Manages different monitoring services
#
# === Parameters
#
# $manage_grafana         Manage grafana instances
#
# $manage_promehteus      Manage prometheus instances
#
class profile::monitoring (
  Boolean $manage_grafana    = false,
  Boolean $manage_prometheus = false,
)
{
  if $manage_grafana {
    class {'::profile::monitoring::grafana': }
  }
  if $manage_prometheus {
    class { '::profile::monitoring::prometheus': }
  }
}
