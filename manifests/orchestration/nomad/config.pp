class profile::orchestration::nomad::config (
  String                $ca_file              = $::profile::orchestration::nomad::ca_file,
  String                $cert_file            = $::profile::orchestration::nomad::cert_file,
  String                $certs_dir            = $::profile::orchestration::nomad::certs_dir,
  String                $cli_cert_file        = $::profile::orchestration::nomad::cli_cert_file,
  String                $cli_key_file         = $::profile::orchestration::nomad::cli_key_file,
  Hash[String, Integer] $extra_firewall_ports = $::profile::orchestration::nomad::extra_firewall_ports,
  String                $group                = $::profile::orchestration::nomad::group,
  Hash[String, Hash]    $host_volumes         = $::profile::orchestration::nomad::host_volumes,
  String                $job_port_range       = $::profile::orchestration::nomad::job_port_range,
  String                $key_file             = $::profile::orchestration::nomad::key_file,
  String                $nomad_client_cert    = $::profile::orchestration::nomad::nomad_client_cert,
  String                $nomad_client_key     = $::profile::orchestration::nomad::nomad_client_key,
  String                $nomad_cli_cert       = $::profile::orchestration::nomad::nomad_cli_cert,
  String                $nomad_cli_key        = $::profile::orchestration::nomad::nomad_cli_key,
  String                $nomad_server_cert    = $::profile::orchestration::nomad::nomad_server_cert,
  String                $nomad_server_key     = $::profile::orchestration::nomad::nomad_server_key,
  String                $root_ca_cert         = $::profile::orchestration::nomad::root_ca_cert,
  Boolean               $server               = $::profile::orchestration::nomad::server,
  String                $user                 = $::profile::orchestration::nomad::user,
){
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['nomad'],
  }

  file { $certs_dir :
    ensure => 'directory',
  }

  file { $ca_file :
    ensure  => 'present',
    content => $root_ca_cert,
  }
  if $server {
    file { $cert_file :
      ensure  => 'present',
      content => $nomad_server_cert,
    }

    file { $key_file :
      ensure  => 'present',
      content => $nomad_server_key,
    }

    file { $cli_cert_file:
      ensure  => 'present',
      content => $nomad_cli_cert,
    }

    file { $cli_key_file:
      ensure  => 'present',
      content => $nomad_cli_key,
    }
  } else {
    file { $cert_file :
      ensure  => 'present',
      content => $nomad_client_cert,
    }

    file { $key_file :
      ensure  => 'present',
      content => $nomad_client_key,
    }
  }

  profile::base::firewall::entry { '200 allow Nomad services':
    port => [$job_port_range],
  }

  profile::base::firewall::entry { '200 allow Nomad http':
    port => 4646,
  }

  profile::base::firewall::entry { '200 allow Nomad rpc':
    port => 4647,
  }

  profile::base::firewall::entry { '200 allow Nomad serf':
    port => 4648,
  }

  $extra_firewall_ports.each |String $service, Integer $port| {
    profile::base::firewall::entry { "200 Nomad ${service} service with static port ${port}":
      port => $port,
    }
  }

  seaweedfs::mount { 'nomad':
    mount_dir => '/nomad',
  }

  $volume_defaults = {
    'owner'  => 'nomad',
    'group'  => 'nomad',
  }

  $host_volumes.each | String $volume_name, Hash $volume_hash | {
    $params = merge($volume_defaults, $volume_hash)
    $_params = $params.filter | $param | {
      !($param[0] in 'read_only')
    }

    file { $volume_hash['path']:
      ensure  => 'directory',
      *       => $_params,
      require => Service['seaweedfs-mount-nomad'],
    }
  }
}
