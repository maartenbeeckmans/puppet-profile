define profile::base::firewall::entry (
  Profile::FirewallAction $action = 'accept',
  Profile::FirewallChain $chain = 'INPUT',
  Optional[String] $interface = undef,
  Optional[Variant[Integer, Array[Integer],Array[String]]] $port = undef,
  Profile::FirewallProtocol $protocol = 'tcp',
  Profile::FirewallProvider $provider = 'iptables',
  Optional[Variant[Profile::FirewallState, Array[Profile::FirewallState]]] $state = undef,
) {
  firewall { $name:
    action   => $action,
    chain    => $chain,
    proto    => $protocol,
    provider => $provider,
  }

  if $interface {
    Firewall[$name] {
      iniface => $interface,
    }
  }

  if $port {
    Firewall[$name] {
      dport => $port,
    }
  }

  if $state {
    Firewall[$name] {
      state => $state,
    }
  }
}
