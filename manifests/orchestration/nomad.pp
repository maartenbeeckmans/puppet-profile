# == Class: profile::orchestration::nomad
#
# Installs and configures nomad server and client
#
class profile::orchestration::nomad (
  String                $advertise_address          = $facts['networking']['ip'],
  Array[String]         $agent_nodes                = [],
  String                $alloc_dir                  = '/var/lib/nomad/alloc',
  Boolean               $auto_advertise             = true,
  String                $bind_address               = '0.0.0.0',
  String                $ca_file                    = "${::profile::orchestration::nomad}/root_ca_cert.pem",
  String                $cert_file                  = "${::profile::orchestration::nomad}/nomad_cert.pem",
  String                $certs_dir                  = '/etc/ssl/certs/nomad',
  String                $cli_cert_file              = "${::profile::orchestration::nomad}/cli_cert.pem",
  String                $cli_key_file               = "${::profile::orchestration::nomad}/cli_key.pem",
  Boolean               $client                     = true,
  Boolean               $client_auto_join           = true,
  String                $client_service_name        = 'nomad-agent',
  String                $collection_interval        = '1s',
  Hash                  $config_defaults            = {},
  String                $consul_address             = 'localhost:8500',
  Boolean               $consul_ssl                 = true,
  Boolean               $consul_verify_ssl          = true,
  String                $datacenter                 = 'default',
  String                $data_dir                   = '/var/lib/nomad',
  Hash[String, Integer] $extra_firewall_ports       = {},
  String                $group                      = 'nomad',
  Hash[String, Hash]    $host_volumes               = undef,
  String                $install_method             = 'url',
  String                $job_port_range             = '20000-32000',
  String                $key_file                   = "${::profile::orchestration::nomad::certs_dir}/nomad_key.pem",
  String                $log_level                  = 'INFO',
  Boolean               $manage_group               = true,
  Boolean               $manage_user                = true,
  Hash[String, String]  $meta                       = {},
  String                $nomad_client_cert          = undef,
  String                $nomad_client_key           = undef,
  String                $nomad_cli_cert             = undef,
  String                $nomad_cli_key              = undef,
  String                $nomad_server_cert          = undef,
  String                $nomad_server_key           = undef,
  String                $node_name                  = $facts['fqdn'],
  Hash                  $plugin_config              = {
    docker      => {
      args      => [],
      config    => {
        gc      => {
          image => false,
        },
        allow_caps => ['ALL'],
      }
    }
  },
  Boolean               $pretty_config              = true,
  Boolean               $prometheus_metrics         = true,
  Boolean               $publish_allocation_metrics = true,
  Boolean               $publish_node_metrics       = true,
  Boolean               $rejoin_after_leave         = true,
  String                $root_ca_cert               = undef,
  Boolean               $server                     = false,
  Array[String]         $server_nodes               = [],
  Boolean               $server_auto_join           = true,
  String                $server_service_name        = 'nomad',
  Boolean               $telemetry_disable_hostname = true,
  Boolean               $tls_http                   = true,
  Boolean               $tls_rpc                    = true,
  String                $user                       ='nomad',
  Hash                  $vault_config               = {
    address   => 'https://vault.service.consul:8200',
    enabled   => true,
    ca_path   => $::profile::orchestration::nomad::ca_file,
    cert_file => '/etc/ssl/certs/vault/vault_cert.pem',
    key_file  => '/etc/ssl/certs/vault/vault_key.pem',
  },
  String                $vault_role                 = 'nomad-cluster',
  String                $vault_token                = undef,
  Boolean               $verify_https_client        = false,
  Boolean               $verify_server_hostname     = true,
  Boolean               $verify_ssl                 = true,
  String                $version                    = '0.11.1',
){
  include ::profile::orchestration::nomad::config

  if ($server) {
    include ::profile::orchestration::nomad::server
  } else {
    include ::profile::orchestration::nomad::agent
  }
}
