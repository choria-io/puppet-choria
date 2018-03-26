# Configures the Choria Broker
#
# @private
class choria::broker::config {
  assert_private()

  file{$choria::broker_config_file:
    owner   => "root",
    group   => $choria::root_group,
    mode    => "0640",
    content => epp("choria/broker.cfg.epp"),
    notify  => Class["choria::broker::service"],
    require => Class["choria::install"]
  }
}
