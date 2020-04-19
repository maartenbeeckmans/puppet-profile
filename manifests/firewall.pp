class profile::firewall (
  String $ensure = 'running',
  Hash $entries = {},
  Boolean $purge = true,
) {
  class { '::firewall':
    ensure => $ensure,
  }

  resources { 'firewall':
    purge => $purge,
  }

  profile::firewall::entry { '000 related,established':
    protocol => 'all',
    state    => [
      'RELATED',
      'ESTABLISHED',
    ],
  }

  create_resources( '::profile::firewall::entry', $entries)
}
