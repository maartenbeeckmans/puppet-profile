# Class profile::params
# =====================
# Sets default parameters for profile class
class profile::params {
  # profile::base
  $default_packages             = ['vim-enhanced', 'tree', 'htop', 'bind-utils']
  if $facts['os']['family'] == 'RedHat' {
    $install_epel               = true
  } else {
    $install_epel               = false
  }
  $selinux_mode                 = 'enforcing'
  $selinux_type                 = 'targeted'
  $motd                         = 'This machine is managed by puppet'
  $fail2ban_services            = ['ssh', 'ssh-ddos']

  # profile::firewall
  $firewall_purge               = true
  $firewall_purge_unmanaged     = true
}
