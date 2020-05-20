# == Class: profile::orchestration::nomad
#
# Installs and configures nomad server and client
#
class profile::orchestration::nomad (
  String                $advertise_address,
  Array[String]         $agent_nodes,
  String                $alloc_dir,
  Boolean               $auto_advertise,
  String                $bind_address,
  String                $ca_file,
  String                $cert_file,
  String                $certs_dir,
  String                $cli_cert_file,
  String                $cli_key_file,
  Boolean               $client,
  Boolean               $client_auto_join,
  String                $client_service_name,
  String                $collection_interval,
  Hash                  $config_defaults,
  String                $consul_address,
  Boolean               $consul_ssl,
  Boolean               $consul_verify_ssl,
  String                $datacenter,
  String                $data_dir,
  Hash[String, Integer] $extra_firewall_ports,
  String                $group,
  Hash[String, Hash]    $host_volumes,
  String                $install_method,
  String                $job_port_range,
  String                $key_file,
  String                $log_level,
  Boolean               $manage_group,
  Boolean               $manage_user,
  Hash[String, String]  $meta,
  String                $nomad_client_cert,
  String                $nomad_client_key,
  String                $nomad_cli_cert,
  String                $nomad_cli_key,
  String                $nomad_server_cert,
  String                $nomad_server_key,
  String                $node_name,
  Hash                  $plugin_config,
  Boolean               $pretty_config,
  Boolean               $prometheus_metrics,
  Boolean               $publish_allocation_metrics,
  Boolean               $publish_node_metrics,
  Boolean               $rejoin_after_leave,
  String                $root_ca_cert,
  Boolean               $server,
  Array[String]         $server_nodes,
  Boolean               $server_auto_join,
  String                $server_service_name,
  Boolean               $telemetry_disable_hostname,
  Boolean               $tls_http,
  Boolean               $tls_rpc,
  String                $user,
  Hash                  $vault_config,
  String                $vault_role,
  String                $vault_token,
  Boolean               $verify_https_client,
  Boolean               $verify_server_hostname,
  Boolean               $verify_ssl,
  String                $version,
){
  include ::profile::orchestration::nomad::config

  if ($server) {
    include ::profile::orchestration::nomad::server
  } else {
    include ::profile::orchestration::nomad::agent
  }
}
