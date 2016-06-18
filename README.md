# puppet-module-eyaml

[![Build Status](https://travis-ci.org/ghoneycutt/puppet-module-eyaml.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-eyaml)

Manage [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml). Meant to be
associated with a puppet master. It will install the hiera-eyaml gem, create
/etc/puppet/keys, generate keys, and manage /etc/eyaml/config.yaml. It does not
modify your hiera.yaml, which must be done to use eyaml. The module is totally
configurable through parameters.

===

# Compatibility

This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3,
2.0.0 and 2.1.0. It is supported on the following platforms.

* EL 6
* EL 7

===

# Parameters

package_name
--------------
Hiera-eyaml requires the hiera-eyaml gem to be installed.

-  *Type*: string
-  *Default*: hiera-eyaml

package_provider
--------------
Package provider to install eyaml.

-  *Type*: string
-  *Default*: gem

package_ensure
--------------
We can enforce an specific version of the gem.

-  *Type*: string
-  *Default*: present

keys_dir
--------------
Directory were we will install our public and private keys.

-  *Type*: string
-  *Default*: "/etc/puppet/keys"

keys_dir_ensure
--------------
Ensures $keys_dir is a directory.

-  *Type*: string
-  *Default*: directory

keys_dir_owner
--------------
Ensures that $keys_dir owner is correct.

-  *Type*: string
-  *Default*: root

keys_dir_group
--------------
Ensures that $keys_dir group is correct.

-  *Type*: string
-  *Default*: root

keys_dir_mode
--------------
Ensures the $keys_dir mode is -r-x------.

-  *Type*: integer
-  *Default*: 0500

public_key_path
--------------
Absolute path to the public key.

-  *Type*: string
-  *Default*: /etc/puppet/keys/public_key.pkcs7.pem

private_key_path
--------------
Absolute path to the private key.

-  *Type*: string
-  *Default*: /etc/puppet/keys/private_key.pkcs7.pem

public_key_mode
--------------
Ensures public key permission are -rw-r--r--.

-  *Type*: integer
-  *Default*: 0644

private_key_mode
--------------
Ensures private key permission are -r--------.

-  *Type*: integer
-  *Default*: 0400

config_dir
--------------
Directory were we want to store eyaml configuration.

-  *Type*: string
-  *Default*: /etc/yaml

config_dir_ensure
--------------

Ensures $config_dir is a directory.

-  *Type*: string
-  *Default*: directory

config_dir_owner
--------------
Ensures $config_dir owner is the expected.

-  *Type*: string
-  *Default*: root

config_dir_group
--------------
Ensures $config_dir group is the expected.

-  *Type*: string
-  *Default*: root

config_dir_mode
--------------
Ensures $config_dir mode is -rwxr-xr-x.

-  *Type*: integer
-  *Default*: 0755

config_ensure
--------------
Ensures config file is a file.

-  *Type*: string
-  *Default*: file

config_path
--------------
hiera-eyaml config file path.

-  *Type*: string
-  *Default*: /etc/eyaml/config.yaml

config_owner
--------------
Config file owner.

-  *Type*: string
-  *Default*: root

config_group
--------------
Config file group.

-  *Type*: string
-  *Default*: root

config_mode
--------------
Config file mode.

-  *Type*: integer
-  *Default*: 0644

config_options
--------------
eyaml custom configurations like (extension, datadir)

-  *Type*: hash
-  *Default*: { 'pkcs7_public_key'  => '/etc/puppet/keys/public_key.pkcs7.pem',
               'pkcs7_private_key' => '/etc/puppet/keys/private_key.pkcs7.pem',
             },

manage_eyaml_config
--------------
Manage eyaml config file.

-  *Type*: bool
-  *Default*: true

manage_keys
--------------
Manage eyaml keys creation

-  *Type*: bool
-  *Default*: undef

