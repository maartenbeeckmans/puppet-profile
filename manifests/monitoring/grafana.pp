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
  Hash    $extra_cfg              = {},
  String  $domainname             = 'http://localhost',
  String  $grafana_port           = '3000',
  String  $admin_user             = 'admin',
  String  $admin_password         = 'secret',
  Boolean $manage_repo            = true,
  String  $version                =  '6.7.3',
  Boolean $manage_firewall_entry  = true,
  Hash    $dashboards             = {
    'Node_exporter' => {
      'content'     => 'profile/monitoring_grafana_node_exporter.json',
    }
  },
  Hash    $datasources            = {
    'Prometheus'    => {
      'access_mode' => 'proxy',
      'url'         => 'http://localhost:9090',
      'type'        => 'prometheus',
      'is_default'  => true,
    }
  },
)
{
  $default_cfg  = {
    server => {
      http_port => $grafana_port,
    },
    users           => {
      allow_sign_up => false,
    },
  }
  $cfg = $default_cfg + $extra_cfg
  class {'grafana':
    cfg                 => $cfg,
    manage_package_repo => $manage_repo,
    version             => $version,
  }
  if $manage_firewall_entry {
    profile::base::firewall::entry { '200 allow grafana':
      port => Integer($grafana_port),
    }
  }
  $defaults = {
    grafana_url      => "${domainname}:${grafana_port}",
    grafana_user     => $admin_user,
    grafana_password => $admin_password,
  }
  create_resources(::profile::monitoring::grafana::dashboard, $dashboards, $defaults )
  create_resources(::profile::monitoring::grafana::datasource, $datasources, $defaults )
}
