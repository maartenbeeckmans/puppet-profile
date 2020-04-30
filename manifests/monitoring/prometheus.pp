# == Class: profile::monitoring::prometheus
#
# Manages prometheus client and server configurations
#
# === Dependencies
#
# - puppet-prometheus
#
# === Parameters
#
# $server       Manage prometheus server
#
# $client       Manage prometheus client
#
class profile::monitoring::prometheus (
  Boolean $server = false,
  Boolean $client = true,
)
{
  if $server {
    class { '::profile::monitoring::prometheus::server': }
  }
  if $client {
    class { '::profile::monitoring::prometheus::node_exporter': }
  }
}
