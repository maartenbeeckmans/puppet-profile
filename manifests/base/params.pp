class profile::base::params {
  case $facts['os']['family'] {
    Array $default_packages = ['vim-enhanced', 'tree', 'htop', 'bind-utils']
  }
  String $motd = "This machine is puppet managed"
}
