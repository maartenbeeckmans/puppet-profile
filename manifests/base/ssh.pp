class profile::base::ssh (
  Array     $ports                    = ['22'],
  Boolean   $storeconfigs_enabled     = false,
  String    $permit_root_login        = 'no',
  String    $password_authentication  = 'yes',
  String    $print_motd               = 'yes',
  String    $x11_forwarding           = 'no',
) {
  class { 'ssh':
    storeconfigs_enabled => $storeconfigs_enabled,
    server_options       => {
      'PasswordAuthentication' => $password_authentication,
      'PermitRootLogin'        => $permit_root_login,
      'Port'                   => $ports,
      'ChrootDirectory'        => '%h',
      'PrintMotd'              => $print_motd,
      'X11Forwarding'          => $x11_forwarding,
    },
    client_options       => {
      'Host *'                => {
        'SendEnv'             => 'LANG LC_*',
        'ForwardX11Trusted'   => $x11_forwarding,
        'ServerAliveInterval' => '10',
      },
    },
    validate_sshd_file   => true,
  }

  $ports.each |String $port| {
    profile::base::firewall::entry { "010 allow ssh port ${port}":
      port => Integer($port),
    }
  }
}
