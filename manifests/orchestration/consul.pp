class profile::orchestration::consul (
  Array[String]    $agent_nodes,
  String           $bind_address,
  String           $ca_file,
  String           $cert_file,
  String           $certs_dir,
  String           $cli_cert_file,
  String           $cli_key_file,
  String           $client_address,
  String           $consul_cli_cert,
  String           $consul_cli_key,
  String           $consul_client_cert,
  String           $consul_client_key,
  String           $consul_server_cert,
  String           $consul_server_key,
  String           $data_dir,
  String           $datacenter,
  String           $domain,
  String           $encrypt_key,
  String           $group,
  String           $key_file,
  String           $log_level,
  Boolean          $manage_group,
  Boolean          $manage_user,
  String           $node_name,
  String           $root_ca_cert,
  Boolean          $server,
  Array[String]    $server_nodes,
  Boolean          $ui,
  String           $user,
  Boolean          $verify_outgoing,
  Boolean          $verify_server_hostname,
  String           $version,
  Optional[String] $download_url         = undef,
){
  include ::profile::orchestration::consul::config

  if ($server) {
    include ::profile::orchestration::consul::server
  } else {
    include ::profile::orchestration::consul::agent
  }
}

