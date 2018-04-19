# Class: choria::broker
#
# @example Choria Broker in a 3 node cluster
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
# @example Choria Broker federating the `development` network
#
#   class{"choria::broker":
#     federation_broker => true,
#     federation_cluster => "development"
#   }
#
# @example Choria Broker with a NATS Stream adapter for registration data
#
#  class{"choria::broker":
#    adapters => {
#      discovery => {
#        stream => {
#          type => "natsstream",
#          servers => ["stan1:4222", "stan2:4222"],
#          clusterid => "prod",
#          topic => "discovery",
#          workers => 10,
#        },
#        ingest => {
#          topic => "mcollective.broadcast.agent.discovery",
#          protocol => "request",
#          workers => 10
#        }
#      }
#    }
#  }
#
# @param network_broker Enable or Disable the network broker
# @param federation_broker Enable or Disable the federation broker
# @param federation_cluster The name of the federation cluster to serve
# @param listen_address Address the network broker will listen on for clients and broker peers
# @param stats_listen_address Address the broker will listen for Prometheus stats
# @param client_port Port clients will connec tto
# @param cluster_peer_port Port other brokers will connect to
# @param stats_port Port where Prometheus stats are hosted
# @param identity The identity this broker will use to determine SSL cert names etc
class choria::broker (
  Boolean $network_broker,
  Boolean $federation_broker,
  Optional[String] $federation_cluster,
  Stdlib::Compat::Ip_address $listen_address,
  Stdlib::Compat::Ip_address $stats_listen_address,
  Integer $client_port,
  Integer $cluster_peer_port,
  Integer $stats_port,
  Array[String] $network_peers,
  Array[String] $federation_middleware_hosts,
  Array[String] $collective_middleware_hosts,
  Choria::Adapters $adapters,
  String $identity
) {
  require choria

  class{"choria::broker::config": }

  ~> class{"choria::broker::service": }

  -> Class[$name]
}
