# == Class: profile::orchestration
#
# This class can be used to set up a nomad container cluster with consul and vault integration
#
# @example when declaring the orchestration class
#  class { '::profile::orchestration': }
#
# === Parameters
#
# $manage_nomad   Set to true if puppet must configure a nomand cluster
#
# $manage_consul  Set to true if puppet must configure consul
#
# $manage_vault   Set to true if puppet must configure vault
#
class profile::orchestration (
  Boolean $manage_nomad = false,
  Boolean $manage_consul = false,
  Boolean $manage_vault = false,
) {
  if $manage_nomad {
    class { '::profile::orchestration::nomad': }
  }
  if $manage_consul {
    class { '::profile::orchestration::consul': }
  }
  if $manage_vault {
    class { '::profile::orchestration::vault': }
  }
}
