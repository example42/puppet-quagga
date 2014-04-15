#
# = Class: quagga
#
# This class installs and manages quagga
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class quagga (

  $package_name             = $quagga::params::package_name,
  $package_ensure           = 'present',

  $service_name             = $quagga::params::service_name,
  $service_ensure           = 'running',
  $service_enable           = true,

  $config_file_path         = $quagga::params::config_file_path,
  $config_file_owner        = $quagga::params::config_file_owner,
  $config_file_group        = $quagga::params::config_file_group,
  $config_file_mode         = $quagga::params::config_file_mode,
  $config_file_require      = 'Package[quagga]',
  $config_file_notify       = 'Service[quagga]',
  $config_file_source       = undef,
  $config_file_template     = undef,
  $config_file_content      = undef,
  $config_file_options_hash = { },

  $config_dir_path          = $quagga::params::config_dir_path,
  $config_dir_source        = undef,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,

  $conf_hash                = undef,

  $dependency_class         = undef,
  $my_class                 = undef,

  $monitor_class            = undef,
  $monitor_options_hash     = { },

  $firewall_class           = undef,
  $firewall_options_hash    = { },

  $scope_hash_filter        = '(uptime.*|timestamp)',

  $tcp_port                 = undef,
  $udp_port                 = undef,

  ) inherits quagga::params {

  # Class variables validation and management
  validate_absolute_path($config_dir_path)
  validate_absolute_path($config_file_path)
  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_string($config_file_mode)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => 'Service[quagga]',
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = 'stopped'
    $config_dir_ensure     = 'absent'
    $config_file_ensure    = 'absent'
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure     = 'directory'
    $config_file_ensure    = 'present'
  }

  # Dependency class
  if $quagga::dependency_class {
    include $quagga::dependency_class
  }

  # Resources managed
  if $quagga::package_name {
    package { 'quagga':
      ensure => $quagga::package_ensure,
      name   => $quagga::package_name,
    }
  }

  if $quagga::config_file_path {
    file { 'quagga.conf':
      ensure  => $quagga::config_file_ensure,
      path    => $quagga::config_file_path,
      mode    => $quagga::config_file_mode,
      owner   => $quagga::config_file_owner,
      group   => $quagga::config_file_group,
      source  => $quagga::config_file_source,
      content => $quagga::manage_config_file_content,
      notify  => $quagga::manage_config_file_notify,
      require => $quagga::config_file_require,
    }
  }

  if $quagga::config_dir_source {
    file { 'quagga.dir':
      ensure  => $quagga::config_dir_ensure,
      path    => $quagga::config_dir_path,
      source  => $quagga::config_dir_source,
      recurse => $quagga::config_dir_recurse,
      purge   => $quagga::config_dir_purge,
      force   => $quagga::config_dir_purge,
      notify  => $quagga::manage_config_file_notify,
      require => $quagga::config_file_require,
    }
  }

  if $quagga::service_name {
    service { 'quagga':
      ensure => $quagga::manage_service_ensure,
      name   => $quagga::service_name,
      enable => $quagga::manage_service_enable,
    }
  }

  # Extra classes
  if $conf_hash {
    create_resources('quagga::conf', $conf_hash)
  }

  if $quagga::my_class {
    include $quagga::my_class
  }

  if $quagga::monitor_class {
    class { $quagga::monitor_class:
      options_hash => $quagga::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $quagga::firewall_class {
    class { $quagga::firewall_class:
      options_hash => $quagga::firewall_options_hash,
      scope_hash   => {},
    }
  }
}
