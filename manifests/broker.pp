# Class: choria::broker
#
# @example Choria broker in a 3 node cluster
#
#    class{"choria::broker":
#       network_broker => true,
#       network_peers => [
#          "nats://choria1:5222",
#          "nats://choria2:5222",
#          "nats://choria3:5222"
#       ]
#    }
#
# @param network_broker Enable or Disable the network broker
# @param listen_address Address the network broker will listen on for clients and broker peers
# @param stats_listen_address Address the broker will listen for Prometheus stats
# @param client_port Port clients will connec tto
# @param cluster_peer_port Port other brokers will connect to
# @param stats_port Port where Prometheus stats are hosted
class choria::broker (
  Boolean $network_broker = false,
  Stdlib::Compat::Ip_address $listen_address = "0.0.0.0",
  Stdlib::Compat::Ip_address $stats_listen_address = "0.0.0.0",
  Integer $client_port = 4222,
  Integer $cluster_peer_port = 5222,
  Integer $stats_port = 8222,
  Array[String] $network_peers = [],
  Stdlib::Compat::Absolute_path $config_file = "/etc/choria/broker.conf"
) {
  require choria

  class{"choria::broker::config": }

  ~> class{"choria::broker::service": }

  -> Class[$name]
}
