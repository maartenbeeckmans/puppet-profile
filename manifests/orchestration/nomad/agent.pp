# == Class: profile::orchestration::nomad::agent
#
# Installs and configures nomad agent
#
class profile::orchestration::nomad::agent (
  String        $advertise_address          = $::profile::orchestration::nomad::advertise_address,
  Array[String] $agent_nodes                = $::profile::orchestration::nomad::agent_nodes,
  String        $alloc_dir                  = $::profile::orchestration::nomad::alloc_dir,
  Boolean       $auto_advertise             = $::profile::orchestration::nomad::auto_advertise,
  String        $bind_address               = $::profile::orchestration::nomad::bind_address,
  String        $ca_file                    = $::profile::orchestration::nomad::ca_file,
  String        $cert_file                  = $::profile::orchestration::nomad::cert_file,
  Boolean       $client                     = $::profile::orchestration::nomad::client,
  Boolean       $client_auto_join           = $::profile::orchestration::nomad::client_auto_join,
  String        $client_service_name        = $::profile::orchestration::nomad::client_service_name,
  String        $collection_interval        = $::profile::orchestration::nomad::collection_interval,
  Hash          $config_defaults            = $::profile::orchestration::nomad::config_defaults,
  String        $consul_address             = $::profile::orchestration::nomad::consul_address,
  String        $consul_ca_file             = $::profile::orchestration::consul::ca_file,
  String        $consul_cert_file           = $::profile::orchestration::consul::cert_file,
  String        $consul_key_file            = $::profile::orchestration::consul::key_file,
  Boolean       $consul_ssl                 = $::profile::orchestration::nomad::consul_ssl,
  Boolean       $consul_verify_ssl          = $::profile::orchestration::nomad::consul_verify_ssl,
  String        $datacenter                 = $::profile::orchestration::nomad::datacenter,
  String        $data_dir                   = $::profile::orchestration::nomad::data_dir,
  String        $group                      = $::profile::orchestration::nomad::group,
  Hash          $host_volumes               = $::profile::orchestration::nomad::host_volumes,
  String        $key_file                   = $::profile::orchestration::nomad::key_file,
  String        $install_method             = $::profile::orchestration::nomad::install_method,
  String        $log_level                  = $::profile::orchestration::nomad::log_level,
  Boolean       $manage_group               = $::profile::orchestration::nomad::manage_group,
  Boolean       $manage_user                = $::profile::orchestration::nomad::manage_user,
  Hash          $meta                       = $::profile::orchestration::nomad::meta,
  String        $node_name                  = $::profile::orchestration::nomad::node_name,
  Hash          $plugin_config              = $::profile::orchestration::nomad::plugin_config,
  Boolean       $pretty_config              = $::profile::orchestration::nomad::pretty_config,
  Boolean       $prometheus_metrics         = $::profile::orchestration::nomad::prometheus_metrics,
  Boolean       $publish_allocation_metrics = $::profile::orchestration::nomad::publish_allocation_metrics,
  Boolean       $publish_node_metrics       = $::profile::orchestration::nomad::publish_node_metrics,
  Array[String] $server_nodes               = $::profile::orchestration::nomad::server_nodes,
  Boolean       $telemetry_disable_hostname = $::profile::orchestration::nomad::telemetry_disable_hostname,
  Boolean       $tls_http                   = $::profile::orchestration::nomad::tls_http,
  Boolean       $tls_rpc                    = $::profile::orchestration::nomad::tls_rpc,
  String        $user                       = $::profile::orchestration::nomad::user,
  Hash          $vault_config               = $::profile::orchestration::nomad::vault_config,
  Boolean       $verify_https_client        = $::profile::orchestration::nomad::verify_https_client,
  Boolean       $verify_server_hostname     = $::profile::orchestration::nomad::verify_server_hostname,
  Boolean       $verify_ssl                 = $::profile::orchestration::nomad::verify_ssl,
  String        $version                    = $::profile::orchestration::nomad::version,
){

  class{ '::nomad':
    config_defaults => $config_defaults,
    config_hash     => {
      advertise  => {
        'http' => $advertise_address,
        'rpc'  => $advertise_address,
        'serf' => $advertise_address,
      },
      bind_addr  => $bind_address,
      client     => {
        alloc_dir   => $alloc_dir,
        enabled     => $client,
        host_volume => $host_volumes,
        meta        => $meta,
        servers     => $server_nodes,
      },
      consul     => {
        address             => $consul_address,
        auto_advertise      => $auto_advertise,
        ca_file             => $consul_ca_file,
        cert_file           => $consul_cert_file,
        client_auto_join    => $client_auto_join,
        client_service_name => $client_service_name,
        key_file            => $consul_key_file,
        ssl                 => $consul_ssl,
        verify_ssl          => $verify_ssl,
      },
      datacenter => $datacenter,
      data_dir   => $data_dir,
      log_level  => $log_level,
      name       => $node_name,
      plugin     => $plugin_config,
      telemetry  => {
        collection_interval        => $collection_interval,
        disable_hostname           => $telemetry_disable_hostname,
        prometheus_metrics         => $prometheus_metrics,
        publish_allocation_metrics => $publish_allocation_metrics,
        publish_node_metrics       => $publish_node_metrics,
      },
      tls        => {
        ca_file                => $ca_file,
        cert_file              => $cert_file,
        http                   => $tls_http,
        key_file               => $key_file,
        rpc                    => $tls_rpc,
        verify_https_client    => $verify_https_client,
        verify_server_hostname => $verify_server_hostname,
      },
      vault      => $vault_config,
    },
    group           => $group,
    install_method  => $install_method,
    manage_group    => $manage_group,
    manage_user     => $manage_user,
    pretty_config   => $pretty_config,
    user            => $user,
    version         => $version,
    require         => Package['unzip'],
  }
}
