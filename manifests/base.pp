# This class can be used to setup a bare minimum node
#
# @example when declaring the base class
#  class { '::profile::base': }
# 
class profile::base (
  Boolean $packages = false,
){
  if $packages {
    class { 'profile::base::packages': }
  }
}
