type Choria::KVBucket = Struct[{
  "history"         => Optional[Integer[1,100]],
  "expire"          => Optional[Integer[0]],
  "replicas"        => Integer[1,5],
  "max_value_size"  => Optional[Integer[-1]],
  "max_bucket_size" => Optional[Integer[-1]],
  "force"           => Optional[Boolean],
  "ensure"          => Optional[Enum["present", "absent"]]
}]
