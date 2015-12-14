class arthurjames::profile_puppetmaster (
  $puppetmaster                = $::fqdn,
  $runmode                     = 'service',
  $server                      = true,
  $server_ca                   = true,
  $server_common_modules_path  = [],
  $server_foreman              = true,
  $server_foreman_url          = "https://${::fqdn}",
  $server_external_nodes       = '/etc/puppet/node.rb',
  $server_implementation       = 'master',
  $server_parser               = 'future',
  $server_passenger            = true,
  $server_puppetdb_host        = $::fqdn,
  $server_reports              = 'puppetdb,foreman',
  $server_storeconfigs_backend = 'puppetdb',
  $show_diff                   = true,
  $splay                       = true,
  $puppetdb_confdir            = '/etc/puppetdb/conf.d'
){

  # Agent and puppetmaster:
  class { '::puppet':
    puppetmaster                => $puppetmaster,
    runmode                     => $runmode,
    server                      => $server,
    server_ca                   => $server_ca,
    server_common_modules_path  => $server_common_modules_path,
    server_environments         => [],
    server_foreman              => $server_foreman,
    server_foreman_url          => $server_foreman_url,
    server_external_nodes       => $server_external_nodes,
    server_implementation       => $server_implementation,
    server_parser               => $server_parser,
    server_passenger            => $server_passenger,
    server_puppetdb_host        => $server_puppetdb_host,
    server_reports              => $server_reports,
    server_storeconfigs_backend => $server_storeconfigs_backend,
    show_diff                   => $show_diff,
    splay                       => $splay
  }

  class { '::puppetdb':
    confdir = $puppetdb_confdir
  }

  # for module development, make sure puppetmaster can pick up your work
  file { '/usr/share/puppet/modules':
    ensure  => 'link',
    target  => '/vagrant/modules',
    force   => true,     
    replace => true,
  }
  Class['::puppet'] -> File['/usr/share/puppet/modules']
}
