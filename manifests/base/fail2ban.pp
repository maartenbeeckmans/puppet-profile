class profile::base::fail2ban (
  Array $services = ['ssh', 'ssh-ddos']
)
{
  class { 'fail2ban':
    jails => $services
  }
}
