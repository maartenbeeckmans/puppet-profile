class profile::orchestration::consul (
  Array[String]    $agent_nodes             = [],
  String           $bind_address            = '0.0.0.0',
  String           $ca_file                 = "${::profile::orchestration::consul::certs_dir}/root_ca_cert.pem",
  String           $cert_file               = "${::profile::orchestration::consul::certs_dir}/consule_cert.pem",
  String           $certs_dir               = '/etc/ssl/certs/consul',
  String           $cli_cert_file           = "${::profile::orchestration::consul::certs_dir}/cli_cert.pem",
  String           $cli_key_file            = "${::profile::orchestration::consul::certs_dir}/cli_key.pem",
  String           $client_address          = '0.0.0.0',
  String           $consul_cli_cert         = undef,
  String           $consul_cli_key          = undef,
  String           $consul_client_cert      = undef,
  String           $consul_client_key       = undef,
  String           $consul_server_cert      = undef,
  String           $consul_server_key       = undef,
  String           $data_dir                = '/var/lib/consul',
  String           $datacenter              = 'default',
  String           $domain                  = 'consul',
  String           $encrypt_key             = undef,
  String           $group                   = 'consul',
  String           $key_file                = "${::profile::orchestration::consul::certs_dir}/consul_key.pem",
  String           $log_level               = 'INFO',
  Boolean          $manage_group            = true,
  Boolean          $manage_user             = true,
  String           $node_name               = $facts['fqdn'],
  String           $root_ca_cert            = undef,
  Boolean          $server                  = false,
  Array[String]    $server_nodes            = [],
  Boolean          $ui                      = true,
  String           $user                    = 'consul',
  Boolean          $verify_outgoing         = true,
  Boolean          $verify_server_hostname  = true,
  String           $version                 = '1.6.2',
  Optional[String] $download_url            = undef,
){
  include ::profile::orchestration::consul::config

  if ($server) {
    include ::profile::orchestration::consul::server
  } else {
    include ::profile::orchestration::consul::agent
  }
}
