class profile::base::accounts (
  Hash $accounts   = {},
  Hash $groups     = {},
  Hash $sudo_confs = {},
)
{
  if length($accounts) > 0 {
    create_resources( 'accounts::user', $accounts)
  }

  if length($groups) > 0 {
    create_resources( 'group', $groups)
  }

  if (length($accounts) > 0) and (length($groups) > 0) {
    Group<||> -> User<||>
  }

  if length($sudo_confs) > 0 {
    class { 'sudo':
      config_file_replace =>  false,
      pruge               =>  false,
    }
    create_resources( 'sudo::conf', $sudo_confs)
  }
}
