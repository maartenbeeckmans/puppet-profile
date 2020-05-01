# == Class: profile::monitoring::grafana
#
# === Dependencies
#
# - puppet-grafana
#
# === Parameters
#
# $manage_firewall_entry      Manage firewall entry
#
class profile::monitoring::grafana (
  Boolean $manage_firewall_entry  = true,
)
{
  class {'grafana': }
  if $manage_firewall_entry {
    profile::base::firewall::entry { '200 allow grafana':
      port => 3000,
    }
  }
}
