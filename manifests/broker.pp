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
#          type => "nats_stream",
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
# @param leafnode_port Port leafnode connections will be accepted on
# @param client_hosts Whitelist of clients that are allowed to connect to broker
# @param adapters Data adapters to configure
# @param leafnode_upstreams Leafnode connections to configure
# @param tls_timeout TLS Handshake timeout (in seconds)
# @param identity The identity this broker will use to determine SSL cert names etc
# @param stream_store Enables Streaming and store data in this path
# @param advisory_retention How long to store server advisories for in the Stream
# @param event_retention How long to store events for in the Stream
# @param machine_retention How long to store Choria Autonomous Agent events
# @param system_user Username to use for access to the System account
# @param system_password Password to use for access to the System account
class choria::broker (
  Boolean $network_broker,
  Boolean $federation_broker,
  Optional[String] $federation_cluster,
  Stdlib::Compat::Ip_address $listen_address,
  Stdlib::Compat::Ip_address $stats_listen_address,
  Integer $client_port,
  Integer $cluster_peer_port,
  Integer $stats_port,
  Integer $leafnode_port,
  Array[String] $network_peers,
  Array[String] $federation_middleware_hosts,
  Array[String] $collective_middleware_hosts,
  Array[String] $client_hosts,
  Choria::Adapters $adapters,
  Choria::Leafnodes $leafnode_upstreams,
  String $identity,
  Optional[Stdlib::Absolutepath] $ssldir = undef,
  Optional[Integer] $tls_timeout = undef,
  Optional[Stdlib::Absolutepath] $stream_store = undef,
  String $advisory_retention,
  String $event_retention,
  String $machine_retention,
  String $system_user,
  String $system_password,
) {
  require choria

  class{"choria::broker::config": }

  ~> class{"choria::broker::service": }

  -> Class[$name]
}
