# == Define: profile::monitoring::grafana::datasource
#
# Manage grafana datasources
#
# === Parameters
#
# $access_mode      Proxy vs direct.
#
# $database         Backend database.
#
# $grafana_password Password for admin account.
#
# $grafana_url      Grafana endpoint.
#
# $grafana_user     Grafana admin user.
#
# $is_default       Make datasource the default.
#
# $password         Backend credential.
#
# $type             Backend type.
#
# $url              Backend location.
#
# $user             Backend credential.
#
define profile::monitoring::grafana::datasource (
  Optional[String]  $access_mode        = undef,
  Optional[String]  $database           = undef,
  Optional[String]  $grafana_password   = undef,
  Optional[String]  $grafana_url        = undef,
  Optional[String]  $grafana_user       = undef,
  Optional[Boolean] $is_default         = false,
  Optional[String]  $password           = undef,
  Optional[String]  $type               = undef,
  Optional[String]  $url                = undef,
  Optional[String]  $user               = undef,
) {
  grafana_datasource { $name:
    access_mode      => $access_mode,
    database         => $database,
    grafana_password => $grafana_password,
    grafana_url      => $grafana_url,
    grafana_user     => $grafana_user,
    is_default       => $is_default,
    password         => $password,
    type             => $type,
    url              => $url,
    user             => $user,
  }
}#
