require "puppet/resource_api"

Puppet::ResourceApi.register_type(
  name: "choria_governor",
  desc: <<-EOS,
  Manage Choria Governors hosted in a Choria Broker

  See https://choria.io/docs/streams/governor/ for more information
  EOS
  attributes: {
    name: {
      type: 'Pattern[/[\Aa-zA-Z0-9_-]+\Z/]',
      desc: "Unique name for this Governor",
      behaviour: :namevar,
    },

    capacity: {
      type: "Integer",
      desc: "How many concurrent slots are available in the Governor",
      default: 1
    },

    expire: {
      type: "Integer",
      desc: "How long before a slot reservation is forcibly timed out",
      default: 0
    },

    replicas: {
      type: "Integer[1,5]",
      desc: "In clustered environments this is how many active Replicas of the data and configuration is kept, odd number is best",
      default: 1,
    },

    collective: {
      type: "String",
      desc: "The Sub-Collective the Governor will listen on, usually 'mcollective'",
      default: "mcollective"
    },

    force: {
      type: "Boolean",
      default: false,
      desc: "When updating replicas the Governor has to be removed and recreated, this can only happen if force is true",
      behaviour: :parameter,
    },

    ensure: {
      type: "Enum[present, absent]",
      desc: "Create or remove the Governor",
      default: "present"
    }
  }
)
