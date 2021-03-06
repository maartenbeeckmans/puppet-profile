# == Class: profile::base::ssh
#
# Manages ssh client and server configuration + firewall
#
# === Dependencies
#
# - saz-ssh
#
# === Parameters
#
# $ports                           Array of ssh ports
#
# $storeconfigs_enabled            Will host keys be written to known_hosts
#
# $permit_root_login               Allow root login with ssh
#
# $password_authentication         Allow password authentication with ssh
#
# $print_motd                      Print motd when connected with ssh
#
# $x11_forwarding                  Allow X11Forwarding with ssh
#
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
