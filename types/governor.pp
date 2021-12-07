type Choria::Governor = Struct[{
  "capacity"   => Optional[Integer[1]],
  "expire"     => Optional[Integer[0]],
  "replicas"   => Integer[1,5],
  "collective" => String,
  "force"      => Optional[Boolean],
  "ensure"     => Optional[Enum["present", "absent"]]
}]
