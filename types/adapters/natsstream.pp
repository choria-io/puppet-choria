type Choria::Adapters::NatsStream = Struct[{
  stream => Struct[{
    type => Enum["natsstream"],
    servers => Array[String],
    clusterid => String,
    topic => String,
    workers => Integer[1,100]
  }],
  ingest => Struct[{
    topic => String,
    protocol => Enum["request", "reply"],
    workers => Integer[1,100]
  }]
}]
