class profile::base::packages (
  $default_packages = $profile::params::default_packages,
  $install_epel     = $profile::params::install_epel,
)
{
  if ($facts['os']['family'] == 'redhat' and $install_epel) {
    package { 'epel-release':
      ensure => present,
    }
  }

  package { $default_packages:
    ensure => present,
  }
}
