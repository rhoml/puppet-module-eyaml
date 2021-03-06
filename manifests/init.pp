# == Class: eyaml
#
# Module to manage eyaml
#
class eyaml (
  $package_name        = 'hiera-eyaml',
  $package_provider    = 'gem',
  $package_ensure      = 'present',
  $keys_dir            = '/etc/puppet/keys',
  $keys_dir_ensure     = 'directory',
  $keys_dir_owner      = root,
  $keys_dir_group      = root,
  $keys_dir_mode       = '0500',
  $public_key_path     = '/etc/puppet/keys/public_key.pkcs7.pem',
  $private_key_path    = '/etc/puppet/keys/private_key.pkcs7.pem',
  $public_key_mode     = '0644',
  $private_key_mode    = '0400',
  $config_dir          = '/etc/eyaml',
  $config_dir_ensure   = 'directory',
  $config_dir_owner    = 'root',
  $config_dir_group    = 'root',
  $config_dir_mode     = '0755',
  $config_ensure       = 'file',
  $config_path         = "${config_dir}/config.yaml",
  $config_owner        = 'root',
  $config_group        = 'root',
  $config_mode         = '0644',
  $config_options      = {
    'pkcs7_public_key'  => '/etc/puppet/keys/public_key.pkcs7.pem',
    'pkcs7_private_key' => '/etc/puppet/keys/private_key.pkcs7.pem',
  },
  $createkeys_path     = '/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin',
  $manage_eyaml_config = true,
  $manage_keys         = undef,
) {

  validate_string($package_name)
  validate_string($package_provider)
  validate_string($package_ensure)
  validate_absolute_path($keys_dir)
  validate_string($keys_dir_ensure)
  validate_string($keys_dir_owner)
  validate_string($keys_dir_group)
  validate_re($keys_dir_mode, '^[0-7]{4}$',
      "eyaml::keys_dir_mode is <${keys_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($public_key_path)
  validate_absolute_path($private_key_path)
  validate_re($public_key_mode, '^[0-7]{4}$',
      "eyaml::public_key_mode is <${public_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_re($private_key_mode, '^[0-7]{4}$',
      "eyaml::private_key_mode is <${private_key_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_dir)
  validate_string($config_dir_ensure)
  validate_string($config_dir_owner)
  validate_string($config_dir_group)
  validate_re($config_dir_mode, '^[0-7]{4}$',
      "eyaml::config_dir_mode is <${config_dir_mode}> and must be a valid four digit mode in octal notation.")
  validate_absolute_path($config_path)
  validate_string($config_owner)
  validate_string($config_group)
  validate_re($config_mode, '^[0-7]{4}$',
      "eyaml::config_mode is <${config_mode}> and must be a valid four digit mode in octal notation.")
  validate_hash($config_options)
  validate_string($createkeys_path)

  if is_string($manage_eyaml_config) == true {
    $manage_eyaml_config_bool = str2bool($manage_eyaml_config)
  } else {
    $manage_eyaml_config_bool = $manage_eyaml_config
  }
  validate_bool($manage_eyaml_config_bool)

  if is_string($manage_keys) == true {
    $manage_keys_bool = str2bool($manage_keys)
  } else {
    $manage_keys_bool = $manage_keys
  }
  validate_bool($manage_keys_bool)

  package { 'eyaml':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
  }

  file { 'eyaml_config_dir':
    ensure  => $config_dir_ensure,
    path    => $config_dir,
    owner   => $config_dir_owner,
    group   => $config_dir_group,
    mode    => $config_dir_mode,
    require => Package['eyaml'],
  }

  if $manage_eyaml_config_bool == true {
    file { 'eyaml_config':
      ensure  => $config_ensure,
      path    => $config_path,
      content => template('eyaml/config.yaml'),
      owner   => $config_owner,
      group   => $config_group,
      mode    => $config_mode,
      require => File['eyaml_config_dir'],
    }
  }

  file { 'eyaml_keys_dir':
    ensure  => $keys_dir_ensure,
    path    => $keys_dir,
    owner   => $keys_dir_owner,
    group   => $keys_dir_group,
    mode    => $keys_dir_mode,
    require => Package['eyaml'],
  }

  if $manage_keys_bool == true {
    exec { 'eyaml_createkeys':
      path    => $createkeys_path,
      command => "eyaml createkeys --pkcs7-private-key=${private_key_path} --pkcs7-public-key=${public_key_path}",
      creates => $private_key_path,
      require => File['eyaml_keys_dir'],
      before  => File['eyaml_privatekey'],
    }
  }

  file { 'eyaml_publickey':
    ensure => file,
    path   => $public_key_path,
    owner  => $keys_dir_owner,
    group  => $keys_dir_group,
    mode   => $public_key_mode,
  }

  file { 'eyaml_privatekey':
    ensure => file,
    path   => $private_key_path,
    owner  => $keys_dir_owner,
    group  => $keys_dir_group,
    mode   => $private_key_mode,
  }
}
