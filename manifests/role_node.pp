# == Class: role_node
#
# Full description of class role_node here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'role_node':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class arthurjames::role_node(
  $collectd_enabled = true,
  $nameservers      = [$ipaddress],
  $searchpath       = [$domain],
) {

  validate_bool( $collectd_enabled )

  include ::ntp
  include ::timezone
  include ::arthurjames::profile_puppet

  if $collectd_enabled {
    notify { 'collectd enabled': }
    include ::arthurjames::profile_collectd
  }

  class { 'resolv_conf':
    nameservers => $nameservers,
    searchpath  => $searchpath,
  }

  Class['resolv_conf'] -> Package <| |>

}
