type Choria::Adapters::ChoriaStreams = Struct[{
  type => Enum["jetstream", "choria_streams"],
  stream => Struct[{
    servers => Array[String],
    topic => String,
    workers => Integer[1,100]
  }],
  ingest => Struct[{
    topic => String,
    protocol => Enum["request", "reply"],
    workers => Integer[1,100]
  }]
}]

