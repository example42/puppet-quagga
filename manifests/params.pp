# Class: quagga::params
#
# Defines all the variables used in the module.
#
class quagga::params {

  $package_name = $::osfamily ? {
    default => 'quagga',
  }

  $service_name = $::osfamily ? {
    default => 'quagga',
  }

  $service_hasstatus = $::osfamily ? {
    'Debian' => false,
    default  => true,
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/quagga/daemons',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/quagga',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
