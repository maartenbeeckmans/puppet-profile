class profile::base::packages (
  $default_packages = ['vim-enhanced', 'tree', 'htop', 'bind-utils'],
)
{
  package { $default_packages:
    ensure => present,
  }
}
