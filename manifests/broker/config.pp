# Configures the Choria Broker
#
# @private
class choria::broker::config {
  assert_private()

  file{$choria::broker_config:
    owner   => "root",
    group   => "root",
    mode    => "0640",
    content => epp("choria/broker.cfg.epp"),
    notify  => Class["choria::broker::service"]
  }
}
