class profile::base::packages (
  Array   $default_packages = $profile::base::params::default_packages,
  Boolean $install_epel     = $profile::base::params::install_epel,
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
