# Configures the Choria Broker
#
# @private
class choria::broker::config {
  assert_private()

  if $choria::broker::stream_store {
    file{$choria::broker::stream_store:
      owner  => "root",
      group  => $choria::config_group,
      mode   => "0750",
      ensure => directory,
      before => File[$choria::broker_config_file]
    }
  }

  $config_dir = dirname($choria::broker_config_file)

  if $choria::broker::provisioning_signer_source != "" {
    file{"${config_dir}/provisioner-signer-certificate.pem":
      owner  => "root",
      group  => $choria::config_group,
      mode   => "0640",
      source => $choria::broker::provisioning_signer_source,
      before => File[$choria::broker_config_file]
    }
  }

  file{$choria::broker_config_file:
    owner   => "root",
    group   => $choria::config_group,
    mode    => "0640",
    content => epp("choria/broker.cfg.epp"),
    notify  => Class["choria::broker::service"],
    require => Class["choria::install"]
  }
}
