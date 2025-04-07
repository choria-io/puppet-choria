# choria/choria

[The Choria Orchestrator](https://choria.io)

A modern Orchestration Engine with roots in The Marionette Collective.  Please review the [Official Documentation](https://choria.io/docs) for installation guidance.

## Usage

### Package Repo and Basic Installation

At present RHEL 7 and 8, Debian Stretch, Buster and Bullseye and Ubuntu Mantic and Noble are supported. The repositories also include packages for other tools like our Stream Replicator etc.

It's best configured using Hiera; to install the YUM/APT Repository and install a particular version with some basic adjustments this will be enough.

```yaml
choria::manage_package_repo: true
choria::version: 0.0.7-1.el%{facts.os.release.major}
choria::srvdomain: prod.example.net
choria::log_level: warn
```

```puppet
include choria
```

Packages and Repositories are signed using [Choria Packages](https://choria.io/RELEASE-GPG-KEY) GPG Key. For those wishing to maintain their own repo mirrors disable `manage_package_repo` and create your own `yumrepo` or `apt::source` resources.

### Configuring the Choria Server

The Choria Server replaces _mcollectived_.

On all your nodes where you wish to run the new service:

```yaml
choria::server: true
choria::manage_package_repo: true
```

On all nodes including those that are pure MCollective and your clients:

```yaml
mcollective_choria::config:
  security.serializer: "json"
```

### Configuring the Choria Broker

In all cases below you need to ensure the `choria::broker` class is used:

```puppet
include choria::broker
```

Configuration for the various scenarios are shown via Hiera, you can run all scenarios on the same instance.

### Configure a Standalone Choria Broker

We can now configure a standalone Choria Broker, it will listen on port 4222 on `::` and on port 8222 on `::1`.  These settings are configurable via other properties of `choria::broker`.

Please review the [Choria Network Broker](https://choria.io/docs/deployment/broker/) documentation for full details.

```yaml
choria::broker::network_broker: true
```

### Configure a Choria Broker Cluster

To configure a Broker Cluster over port 4223 you can add this data:

```yaml
choria::broker::network_peers:
  - nats://choria1.example.net:4223
  - nats://choria2.example.net:4223
  - nats://choria3.example.net:4223
```

This will build a TLs secures Choria Broker Cluster

### Configure Federation Brokers

To Federate a network - `london` - into a Federated Collective you'd run a Federation Broker in the `london` LAN with the following configuration:

Please review the [Federations of Collectives](https://choria.io/docs/federation/) documentation for full details.

```yaml
choria::broker::federation_broker: true
choria::broker::federation_cluster: london
```

This will use the SRV domain configured in `choria::srvdomain` to find the brokers to connect to as per the documentation.

You can configure custom addresses to connec to:

```yaml
choria::broker::federation_middleware_hosts:
  - choria1.central.example.net:4222
  - choria2.central.example.net:4222
  - choria3.central.example.net:4222
choria::broker::collective_middleware_hosts:
  - choria1.london.example.net:4222
  - choria2.london.example.net:4222
  - choria3.london.example.net:4222
```

### Configure a NATS Streaming Adapter

Given a NATS Stream server with a cluster id `prod_stream` this will adapt Registration messages received in the Collective to the NATS Stream for processing using Stream Processing patterns.

Please review the [Data Adapters](https://choria.io/docs/adapters/) documentation for full details.

```yaml
choria::broker::adapters:
  discover:
    stream:
      type: "nats_stream"
      clusterid: prod_stream
      topic: discovery
      workers: 10
      servers:
        - stan1.example.net:4222
        - stan2.example.net:4222
        - stan3.example.net:4222
    ingest:
      topic: mcollective.broadcast.agent.discovery
      protocol: request
      workers: 10
```
