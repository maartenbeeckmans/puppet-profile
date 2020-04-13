class profile::params {
  # profile::base
  Array           $default_packages             = ['vim-enhanced', 'tree', 'htop', 'bind-utils'],
  String          $selinux_mode                 = "enforcing",
  String          $selinux_type                 = "targeted",
  String          $motd                         = "This machine is puppet managed",
  Array           $fail2ban_services            = ['ssh', 'ssh-ddos'],

  # profile::firewall
  Boolean         $firewall_purge               = true,
  Boolean         $firewall_purge_unmanaged     = true, 
}
