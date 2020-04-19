class profile::base::resolv (
  Optional[String]  $domain       = undef,
  Array             $name_servers = ['127.0.0.1'],
  Array             $searchpath   = [],
)
{
  class { 'resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }
}
