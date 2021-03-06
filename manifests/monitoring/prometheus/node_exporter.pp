# == Class: profile::monitoring::prometheus::node_exporter
#
# Manages prometheus node_exporter
#
# === Parameters
#
# $version                Version of prometheus node_exporter
#
# $collectors             Collectors to export
#
# $manage_firewall_entry  Manage firewall entry
#
class profile::monitoring::prometheus::node_exporter (
  String $version                 = '0.18.1',
  Array $collectors               = ['diskstats','filesystem','loadavg','meminfo','netdev','stat','tcpstat','time','vmstat'],
  Boolean $manage_firewall_entry  = true,
)
{
  class { 'prometheus::node_exporter':
    version    => $version,
    collectors => $collectors,
  }
  if $manage_firewall_entry {
    ::profile::base::firewall::entry { '200 allow node_exporter':
      port => 9100,
    }
  }
}
