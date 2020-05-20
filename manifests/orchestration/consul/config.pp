class profile::orchestration::consul::config (
  String  $ca_file            = $::profile::orchestration::consul::ca_file,
  String  $cert_file          = $::profile::orchestration::consul::cert_file,
  String  $certs_dir          = $::profile::orchestration::consul::certs_dir,
  String  $cli_cert_file      = $::profile::orchestration::consul::cli_cert_file,
  String  $cli_key_file       = $::profile::orchestration::consul::cli_key_file,
  String  $consul_cli_cert    = $::profile::orchestration::consul::consul_cli_cert,
  String  $consul_cli_key     = $::profile::orchestration::consul::consul_cli_key,
  String  $consul_client_cert = $::profile::orchestration::consul::consul_client_cert,
  String  $consul_client_key  = $::profile::orchestration::consul::consul_client_key,
  String  $consul_server_cert = $::profile::orchestration::consul::consul_server_cert,
  String  $consul_server_key  = $::profile::orchestration::consul::consul_server_key,
  String  $key_file           = $::profile::orchestration::consul::key_file,
  String  $root_ca_cert       = $::profile::orchestration::consul::root_ca_cert,
  Boolean $server             = $::profile::orchestration::consul::server,
  Boolean $ui                 = $::profile::orchestration::consul::ui,
){

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['consul'],
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
      content => $consul_server_cert,
    }

    file { $key_file :
      ensure  => 'present',
      content => $consul_server_key,
    }

    file { $cli_cert_file :
      ensure  => 'present',
      content => $consul_cli_cert,
    }

    file { $cli_key_file :
      ensure  => 'present',
      content => $consul_cli_key,
    }
  } else {
    file { $cert_file :
      ensure  => 'present',
      content => $consul_client_cert,
    }

    file { $key_file :
      ensure  => 'present',
      content => $consul_client_key,
    }
  }

  if $ui {
    profile::base::firewall::entry { '100 allow consul ui':
      port => 8500,
    }
  }

  profile::base::firewall::entry { '100 allow consul DNS tcp':
    port     => 8600,
    protocol => 'tcp',
  }

  profile::base::firewall::entry { '100 allow consul DNS udp':
    port     => 8600,
    protocol => 'udp',
  }

  if $server {
    profile::base::firewall::entry { '100 allow consul rpc':
      port => 8300,
    }

    profile::base::firewall::entry { '100 allow consul serf LAN':
      port => 8301,
    }

    profile::base::firewall::entry { '100 allow consul serf WAN':
      port => 8302,
    }
  }
}

