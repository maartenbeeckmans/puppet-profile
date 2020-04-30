class profile::base::motd (
  Boolean $use_template     = false,
  String  $motd_message = 'This machine is managed by Puppet',
)
{
  if $use_template {
    class {'motd':
      template => 'profile/base_motd.epp'
    }
  } else {
    class {'motd':
      content =>  $motd_message,
    }
  }
}
