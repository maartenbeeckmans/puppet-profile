class profile::base::puppet_agent (
  $package_version = '6.14.0',
  $manage_repo = true,
)
{
  class {'::puppet_agent':
    package_version => $package_version,
    manage_repo     => $manage_repo,
    is_pe           => false,
  }
}
