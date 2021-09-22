require "puppet/resource_api"

Puppet::ResourceApi.register_type(
  name: "choria_kv_bucket",
  desc: <<-EOS,
  Manage Choria Key-Value store Buckets hosted in Choria Broker

  See https://choria.io/docs/streams/key-value/ for more information
  EOS

  attributes: {
    name: {
      type: 'Pattern[/[\Aa-zA-Z0-9_-]+\Z/]',
      desc: "Unique name for this Bucket",
      behaviour: :namevar,
    },

    history: {
      type: "Integer[1,100]",
      desc: "How many historic values to keep for any key in the bucket",
      default: 1
    },

    expire: {
      type: "Integer",
      desc: "How long before a value expires from the bucket, in seconds",
      default: -1
    },

    replicas: {
      type: "Integer[1,5]",
      desc: "In clustered environments this is how many active Replicas of the data and configuration is kept, odd number is best",
    },

    max_value_size: {
      type: "Integer",
      desc: "The maximum size for any value that will be accepted by the bucket",
      default: -1
    },

    max_bucket_size: {
      type: "Integer",
      desc: "The maximum size of all values in the bucket, including history, before writes will fail",
      default: -1,
    },

    force: {
      type: "Boolean",
      default: false,
      desc: "When updating replicas the Bucket has to be removed and recreated, this can only happen if force is true",
      behaviour: :parameter,
    },

    ensure: {
      type: "Enum[present, absent]",
      desc: "Create or remove the Bucket",
      default: "present"
    }
  }
)
