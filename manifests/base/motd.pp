class profile::base::motd (
  String  $motd_message = $profile::params::motd,
)
{
  class {'motd':
    content =>  $motd_message,
  }
}
