# == Class arthurjames::profile_grafana
#
#
#-;log_rotate = true
#-
#-# Max line number of single file, default is 1000000
#-;max_lines = 1000000
#-
#-# Max size shift of single file, default is 28 means 1 << 28, 256MB
#-;max_lines_shift = 28
#-
#-# Segment log daily, default is true
#-;daily_rotate = true
#-
#-# Expired days of log file(delete after max days), default is 7
#-;max_days = 7
class arthurjames::profile_grafana (
  $allow_sign_up               = true,
  $allow_org_create            = false,
  $auto_assign_org             = true,
  $auth_assign_org_role        = 'Viewer',
  $admin_password              = 'changeme',
  $admin_user                  = 'admin',
  $cookie_username             = 'grafana_user',
  $cookie_remember_name        = 'grafana_remember',
  $data_source_proxy_whitelist = '',
  $db_datadir                  = '/var/lib/pgsql/data',
  $db_host                     = '127.0.0.1:5432',
  $db_name                     = 'grafana',
  $db_password                 = 'changeme',
  $db_path                     = undef,
  $db_type                     = 'postgres',
  $db_user                     = 'grafana',
  $disable_gravatar            = false,
  $install_method              = 'repo',
  $log_buffer_length           = 10000,
  $log_rotate                  = true,
  $log_max_lines               = 1000000,
  $log_max_lines_shift         = 28,
  $log_daily_rotate            = true,
  $login_remember_days         = 7,
  $log_level                   = 'Info',
  $log_max_days                = 7,
  $logmode                     = 'console, file',
  $secret_key                  = 'inWSYLbKCoLko',
  $vhosts                      = {
    'grafana.arthurjames.vagrant' => {
      proxy_dest => 'http://127.0.0.1:3000'
    },
  }

){

  class { 'grafana':
    install_method => $install_method,
    cfg            => {
      server            => {
        protocol  => 'http',
        http_addr => '127.0.0.1',
      },
      'auth.anonymous'  => {
        enabled  => true,
        org_name => 'ArthurJames',
        org_role => 'Viewer'
      },
      'auth.basic'      => {
        enabled => true
      },
      'auth.proxy'      => {
        enabled         => false,
        header_name     => 'X-WEBAUTH-USER',
        header_property => 'username',
        auto_sign_up    => true,
      },
      event_publisher   => {
        enabled      => false,
        rabbitmq_url => '',
        exchange     => 'grafana_events',
      },
      'dashboards.json' => {
        enabled => false,
        path    => '/var/lib/grafana/dashboards',
      },
      database          => {
        host     => $db_host,
        name     => $db_name,
        password => $db_password,
        path     => $db_path,
        'type'   => $db_type,
        user     => $db_user,
      },
      log               => {
        mode       => $logmode,
        buffer_len => $log_buffer_length,
        level      => $log_level,
      },
      'log.console'     => {
        level => '',
      },
      'log.file'        => {
        log_rotate      => $log_rotate,
        max_lines       => $log_max_lines,
        max_lines_shift => $log_max_lines_shift,
        daily_rotate    => $log_daily_rotate,
        max_days        => $log_max_days,
      },
      security          => {
        admin_user                  => $admin_user,
        admin_password              => $admin_password,
        secret_key                  => $secret_key,
        login_remember_days         => $login_remember_days,
        cookie_username             => $cookie_username,
        cookie_remember_name        => $cookie_remember_name,
        disable_gravatar            => $disable_gravatar,
        data_source_proxy_whitelist => $data_source_proxy_whitelist,
      },
      users             => {
        allow_sign_up        => $allow_sign_up,
        allow_org_create     => $allow_org_create,
        auto_assign_org      => $auto_assign_org,
        auth_assign_org_role => $auth_assign_org_role,
      },

    },
  }

  $vhost_defaults = {
    vhost_name     => '*',
    docroot        => '/var/www',
    error_log      => true,
    port           => 80,
    ssl            => false,
    ssl_protocol   => ['All', '-SSLv2', '-SSLv3'],
    ssl_cipher     => 'AES128+EECDH:AES128+EDH',
  }

  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )
}

