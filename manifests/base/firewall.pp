class profile::base::firewall (
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

  profile::base::firewall::entry { '000 related,established':
    protocol => 'all',
    state    => [
      'RELATED',
      'ESTABLISHED',
    ],
  }

  create_resources( '::profile::firewall::entry', $entries)
}
