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
#          type => "choria_streams",
#          servers => ["choria1:4222", "choria2:4222"],
#          topic => "choria.node_metadata.%s",
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
# @param manage_service Manage the choria-broker service
# @param listen_address Address the network broker will listen on for clients and broker peers
# @param stats_listen_address Address the broker will listen for Prometheus stats
# @param client_port Port clients will connect to using the core NATS protocol
# @param websocket_port Port clients will connect to using NATS over Websockets
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
# @param provisioner_password The Password the Choria Provisioner needs to present
# @param provisioning_signer_source A Puppet source where the public used to sign provisioning.jwt is found
# @param $cluster_name Configures a unique location specific name, use when establishing leafnodes to a central network
# @param $issuer Defines a Choria Protocol version 2 Issuer
# @param $choria_security Configures the Choria Protocol version 2 security plugin
class choria::broker (
  Boolean $network_broker,
  Boolean $federation_broker,
  Boolean $manage_service,
  Stdlib::Host $listen_address,
  Stdlib::Host $stats_listen_address,
  Integer $client_port,
  Integer $websocket_port,
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
  String $advisory_retention,
  Integer $advisory_replicas,
  String $event_retention,
  Integer $event_replicas,
  String $machine_retention,
  Integer $machine_replicas,
  String $system_user,
  String $system_password,
  String $provisioner_password,
  String $provisioning_signer_source,
  Optional[String] $federation_cluster,
  Optional[String] $cluster_name,
  Optional[Stdlib::Absolutepath] $ssldir = undef,
  Optional[Integer] $tls_timeout = undef,
  Optional[Stdlib::Absolutepath] $stream_store = undef,
  Optional[Choria::Issuer] $issuer = undef,
  Optional[Choria::ChoriaSecurity] $choria_security = undef,
) {
  require choria

  class{"choria::broker::config": }

  ~> class{"choria::broker::service": }

  -> Class[$name]
}
