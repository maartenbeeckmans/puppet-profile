# == class: profile::puppet
#
# Installs puppet agent or server on host system
# 
# === Dependencies
#
# - theforeman/puppet
#
# === Params
#
# $allow_any_crl_auth          Allow certificate signing by proxied requests.
#
# $autosign                    Autosigning requests.
#
# $autosign_domains            List of domains to trust while autosigning.
#
# $dns_alt_names               List of additional dns names to sign into certificate.
#
# $environment                 Environment for node.
#
# $hiera_yaml_datadir (String) Hiera directory
#
# $install_vault               Install vault gem
#
# $puppetmaster                Puppetmaster fqdn
#
# $runmode                     How to run puppet
#
# $runinterval                 Run interval.
#
# $server                      Is this a puppetmaster.
#
# $server_additional_settings  Additional settings
#
# $server_ca                   Is this a CA.
#
# $server_common_modules_path  List of module directories.
#
# $server_external_nodes       Location of ENC script.
#
# $server_jvm_max_heap_size    JVM max heap setting.
#
# $server_jvm_min_heap_size    JVM min heap setting.
#
# $server_parser               Puppet parser name.
#
# $server_puppetdb_host        Puppetdb fqdn.
#
# $server_reports              How to store reports.
#
# $server_storeconfigs_backend Puppetdb version option.
#
# $show_diff                   Show diff in puppet report.
#
# $splay                       Start puppet at random time to spread load.
#
# $splaylimit                  Splay with this timeframe.
#
# $srv_domain                  domain to query.
#
# $use_srv_records             Use srv records.
#
class profile::puppet (
  Boolean                                 $allow_any_crl_auth             = true,
  Variant[Boolean, Stdlib::Absolutepath]  $autosign                       = true,
  Array                                   $autosign_domains               = ['*.vagrant'],
  Array                                   $dns_alt_names                  = [],
  String                                  $environment                    = $::environment,
  String                                  $hiera_yaml_datadir             = '/var/lib/hiera',
  Boolean                                 $install_vault                  = false,
  Boolean                                 $install_puppetdb               = false,
  Boolean                                 $install_puppetboard            = false,
  Boolean                                 $manage_firewall_entry          = true,
  Optional[String]                        $puppetmaster                   = 'puppet',
  String                                  $runmode                        = 'service',
  Integer                                 $runinterval                    = 1800,
  Boolean                                 $server                         = false,
  Hash                                    $server_additional_settings     = {},
  Boolean                                 $server_ca                      = true,
  Array                                   $server_common_modules_path     = [],
  String                                  $server_external_nodes          = '/etc/puppetlabs/puppet/node.rb',
  Optional[Stdlib::Host]                  $server_graphite_host           = undef,
  Optional[Stdlib::Port::Unprivileged]    $server_graphite_port           = undef,
  String                                  $server_jvm_max_heap_size       = '512m',
  String                                  $server_jvm_min_heap_size       = '512m',
  String                                  $server_parser                  = 'current',
  Optional[String]                        $server_puppetdb_host           = undef,
  String                                  $server_reports                 = 'store',
  Boolean                                 $server_ship_metrics            = false,
  Optional[String]                        $server_storeconfigs_backend    = undef,
  Boolean                                 $show_diff                      = true,
  Boolean                                 $splay                          = true,
  String                                  $splaylimit                     = '1800s',
  String                                  $srv_domain                     = 'example.org',
  Boolean                                 $use_srv_records                = false,
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

    if $install_vault {
      package { 'hiera-vault':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    if $install_puppetdb {
      class { '::profile::puppet::puppetdb': }
    }

    if $install_puppetboard {
      class { '::profile::puppet::puppetboard': }
    }

    if $manage_firewall_entry {
      profile::base::firewall::entry { '100 allow puppetmaster':
        port => 8140,
      }
    }
  }

  file { 'csr_attributes.yaml':
    ensure => absent,
    backup => false,
    path   => "${settings::confdir}/csr_attributes.yaml",
  }
}
