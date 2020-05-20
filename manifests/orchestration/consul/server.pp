class profile::orchestration::consul::server (
  Array[String]    $agent_nodes            = $::profile::orchestration::consul::agent_nodes,
  String           $bind_address           = $::profile::orchestration::consul::bind_address,
  String           $ca_file                = $::profile::orchestration::consul::ca_file,
  String           $cert_file              = $::profile::orchestration::consul::cert_file,
  String           $client_address         = $::profile::orchestration::consul::client_address,
  String           $data_dir               = $::profile::orchestration::consul::data_dir,
  String           $datacenter             = $::profile::orchestration::consul::datacenter,
  String           $domain                 = $::profile::orchestration::consul::domain,
  Optional[String] $download_url           = $::profile::orchestration::consul::download_url,
  String           $encrypt_key            = $::profile::orchestration::consul::encrypt_key,
  String           $group                  = $::profile::orchestration::consul::group,
  String           $log_level              = $::profile::orchestration::consul::log_level,
  String           $key_file               = $::profile::orchestration::consul::key_file,
  Boolean          $manage_group           = $::profile::orchestration::consul::manage_group,
  Boolean          $manage_user            = $::profile::orchestration::consul::manage_user,
  String           $node_name              = $::profile::orchestration::consul::node_name,
  Array[String]    $server_nodes           = $::profile::orchestration::consul::server_nodes,
  Boolean          $ui                     = $::profile::orchestration::consul::ui,
  String           $user                   = $::profile::orchestration::consul::user,
  Boolean          $verify_outgoing        = $::profile::orchestration::consul::verify_outgoing,
  Boolean          $verify_server_hostname = $::profile::orchestration::consul::verify_server_hostname,
  String           $version                = $::profile::orchestration::consul::version,
){

  class { '::consul' :
    config_hash    => {
      bind_addr              => $bind_address,
      bootstrap_expect       => size($server_nodes),
      ca_file                => $ca_file,
      cert_file              => $cert_file,
      client_addr            => $client_address,
      data_dir               => $data_dir,
      datacenter             => $datacenter,
      dns_config             => {
        service_ttl =>  {
          '*' => '120s'
        }
      },
      domain                 => $domain,
      encrypt                => $encrypt_key,
      key_file               => $key_file,
      log_level              => $log_level,
      node_name              => $node_name,
      ports                  => {
        http  => '-1',
        https => '8500',
      },
      retry_join             => concat($server_nodes, $agent_nodes),
      server                 => true,
      ui                     => $ui,
      verify_outgoing        => $verify_outgoing,
      verify_server_hostname => $verify_server_hostname,
    },
    download_url   => $download_url,
    group          => $group,
    install_method => 'url',
    manage_group   => $manage_group,
    manage_user    => $manage_user,
    user           => $user,
    version        => $version,
  }
}

