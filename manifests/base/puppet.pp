class profiles::bootstrap::puppet (
  Boolean $allow_any_crl_auth = true,
  Variant[Boolean, Stdlib::Absolutepath] $autosign = true,
  Array $autosign_domains = ['*.vagrant'],
  Array $dns_alt_names = [], 
  String $environment = $::environment,
  Boolean $foreman_repo = false,
  String $hiera_yaml_datadir = '/var/lib/hiera',
  Boolean $install_toml = false,
  Boolean $install_vault = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Optional[String] $puppetmaster ='puppet',
  String $runmode = 'service',
  Integer $runinterval = 1800,
  String $sd_service_name = 'puppet',
  Array $sd_service_tags = [], 
  Boolean $server = false,
  Hash $server_additional_settings = {}, 
  Boolean $server_ca = true,
  Array $server_common_modules_path = [], 
  String $server_external_nodes = '/etc/puppetlabs/puppet/node.rb',
  Boolean $server_foreman = false,
  String $server_foreman_url = 'http://foreman',
  Optional[Stdlib::Host] $server_graphite_host = undef,
  Optional[Stdlib::Port::Unprivileged] $server_graphite_port = undef,
  String $server_jvm_max_heap_size = '512m',
  String $server_jvm_min_heap_size = '512m',
  String $server_parser = 'current',
  Optional[String] $server_puppetdb_host = undef,
  String $server_reports = 'store',
  Boolean $server_ship_metrics = false,
  Optional[String] $server_storeconfigs_backend = undef,
  Boolean $show_diff = true,
  Boolean $splay = true,
  String $splaylimit = '1800s',
  String $srv_domain = 'example.org',
  Boolean $use_srv_records = false,
)
{
  class { '::puppet':
    allow_any_crl_auth             => $allow_any_crl_auth,
    autosign                       => $autosign,
    autosign_entries               => $autosign_domains,
    dns_alt_names                  => $dns_alt_names,
    environment                    => $environment,
    puppetmaster                   => $puppetmaster,
    runmode                        => $runmode,
    runinterval                    => $runinterval,
    server                         => $server,
    server_additional_settings     => $server_additional_settings,
    server_ca                      => $server_ca,
    server_common_modules_path     => $server_common_modules_path,
    server_external_nodes          => $server_external_nodes,
    server_foreman                 => $server_foreman,
    server_foreman_url             => $server_foreman_url,
    server_metrics_graphite_enable => $server_ship_metrics,
    server_metrics_graphite_host   => $server_graphite_host,
    server_metrics_graphite_port   => $server_graphite_port,
    server_jvm_max_heap_size       => $server_jvm_max_heap_size,
    server_jvm_min_heap_size       => $server_jvm_min_heap_size,
    server_parser                  => $server_parser,
    server_puppetdb_host           => $server_puppetdb_host,
    server_reports                 => $server_reports,
    server_storeconfigs_backend    => $server_storeconfigs_backend,
    show_diff                      => $show_diff,
    splay                          => $splay,
    splaylimit                     => $splaylimit,
    srv_domain                     => $srv_domain,
    use_srv_records                => $use_srv_records,
  }
  if $server {
    if versioncmp($::puppetversion, '4.0.0') <= 0 {
      file { 'hiera.yaml':
        mode    => '0644',
        owner   => 'puppet',
        group   => 'puppet',
        content => template('profiles/hiera.yaml.erb'),
        path    => '/etc/puppetlabs/puppet/hiera.yaml',
      }
      Class['::puppet']
      -> File['hiera.yaml']
    }

    if $foreman_repo {
      foreman::install::repos { 'foreman':
        repo     => 'stable',
      }
      Foreman::Install::Repos['foreman']
      -> Class['::puppet']
    }

    if $install_toml {
      package { 'toml-rb':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    if $install_vault {
      package { 'hiera-vault':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '100 allow puppetmaster':
        port => 8140,
      }
    }
    if $manage_sd_service {
      ::profiles::orchestration::consul::service { $sd_service_name:
        checks => [
          {
            tcp      => "${::ipaddress}:8140",
            interval => '10s'
          }
        ],
        port   => 8140,
        tags   => $sd_service_tags,
      }
    }
  }

  file { 'csr_attributes.yaml':
    ensure => absent,
    backup => false,
    path   => "${settings::confdir}/csr_attributes.yaml",
  }
}
