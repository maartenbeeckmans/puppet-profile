class profile::base::motd (
  String  $motd_message = $profile::base::params::motd,
)
{
  class {'motd':
    content =>  $motd_message,
  }
}
