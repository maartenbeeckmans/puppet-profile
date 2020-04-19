class profile::base::motd (
  String  $motd_message = "This machine is managed by Puppet"
)
{
  class {'motd':
    content =>  $motd_message,
  }
}
