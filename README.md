#quagga

## DEPRECATION NOTICE
This module is no more actively maintained and will hardly be updated.

Please find an alternative module from other authors or consider [Tiny Puppet](https://github.com/example42/puppet-tp) as replacement.

If you want to maintain this module, contact [Alessandro Franceschi](https://github.com/alvagante)


####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Resources managed by quagga module](#resources-managed-by-quagga-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module quagga](#beginning-with-module-quagga)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures quagga.

##Module Description

The module is based on **stdmod** naming standards version 0.9.0.

Refer to http://github.com/stdmod/ for complete documentation on the common parameters.

##Setup

###Resources managed by quagga module
* This module installs the quagga package
* Enables the quagga service
* Can manage all the configuration files (by default no file is changed)

###Setup Requirements
* PuppetLabs [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)
* StdMod [stdmod module](https://github.com/stdmod/stdmod)
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module quagga

To install the package provided by the module just include it:

```puppet
     include quagga
```

The main class arguments can be provided either via Hiera (from Puppet 3.x) or direct parameters:

```puppet
     class { 'quagga':
       parameter => value,
     }
```

The module provides also a generic define to manage any quagga configuration file:

```puppet
     quagga::conf { 'sample.conf':
       content => '# Test',
     }
```

##Usage

* A common way to use this module involves the management of the main configuration file via a custom template (provided in a custom site module):

```puppet
     class { 'quagga':
       config_file_template => 'site/quagga/quagga.conf.erb',
     }
```

* You can write custom templates that use setting provided but the config_file_options_hash paramenter

```puppet
     class { 'quagga':
       config_file_template      => 'site/quagga/quagga.conf.erb',
       config_file_options_hash  => {
         opt  => 'value',
         opt2 => 'value2',
       },
     }
```

* Use custom source (here an array) for main configuration file. Note that template and source arguments are alternative.

```puppet
     class { 'quagga':
       config_file_source => [ "puppet:///modules/site/quagga/quagga.conf-${hostname}" ,
                               "puppet:///modules/site/quagga/quagga.conf" ],
     }
```

* Use custom source directory for the whole configuration directory, where present.

```puppet
     class { 'quagga':
       config_dir_source  => 'puppet:///modules/site/quagga/conf/',
     }
```

* Use custom source directory for the whole configuration directory and purge all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

```puppet
     class { 'quagga':
       config_dir_source => 'puppet:///modules/site/quagga/conf/',
       config_dir_purge  => true, # Default: false.
     }
```

* Use custom source directory for the whole configuration dir and define recursing policy.

```puppet
     class { 'quagga':
       config_dir_source    => 'puppet:///modules/site/quagga/conf/',
       config_dir_recursion => false, # Default: true.
     }
```

* Provide an hash of files resources to be created with quagga::conf.

```puppet
     class { 'quagga':
       conf_hash => {
         'quagga.conf' => {
           template => 'site/quagga/quagga.conf',
         },
         'quagga.other.conf' => {
           template => 'site/quagga/quagga.other.conf',
         },
       },
     }
```

* Do not trigger a service restart when a config file changes.

```puppet
     class { 'quagga':
       config_dir_notify => '', # Default: Service[quagga]
     }
```

##Operating Systems Support

This is tested on these OS:
- RedHat osfamily 5 and 6
- Debian 6 and 7
- Ubuntu 10.04 and 12.04

##Development

Pull requests (PR) and bug reports via GitHub are welcomed.

When submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests
- Follow the module style and stdmod naming standards

When submitting bug report please include or link:
- The Puppet code that triggers the error
- The output of facter on the system where you try it
- All the relevant error logs
- Any other information useful to undestand the context
