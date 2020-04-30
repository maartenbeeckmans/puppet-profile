class profile::base::ssh (
  String $allow_agent_forwarding = 'no',
  String $forward_agent = 'no',
  String $password_authentication = 'no',
  String $port = '22',
) {
  class { '::ssh::client':
    forward_agent           => $forward_agent,
    password_authentication => $password_authentication,
  }
  class { '::ssh::server':
    allow_agent_forwarding  => $allow_agent_forwarding,
    password_authentication => $password_authentication,
    port                    => $port,
  }

  profile::base::firewall::entry { '010 allow ssh':
    port => Integer($port),
  }
}
