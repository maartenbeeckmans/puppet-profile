# == Define: profile::monitoring::grafana::dashboard
#
# Type to manage grafana dashboard
#
# === Params
#
# $content          Path to json-file.
# $grafana_password Password for admin account.
# $grafana_url      Grafana endpoint.
# $grafana_user     Grafana admin user.
define profile::monitoring::grafana::dashboard (
  Optional[String] $content           = undef,
  Optional[String] $grafana_password  = undef,
  Optional[String] $grafana_url       = undef,
  Optional[String] $grafana_user      = undef,
) {
  grafana_dashboard { $name:
    content          => template( $content ),
    grafana_password => $grafana_password,
    grafana_url      => $grafana_url,
    grafana_user     => $grafana_user,
  }
}
