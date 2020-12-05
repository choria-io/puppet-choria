type Choria::ScoutMetric = Struct[{
  "command"   => String,
  "arguments" => Optional[String],
  "ensure"    => Optional[Enum["present", "absent"]],
  "interval"  => Optional[Choria::Duration],
  "labels"    => Optional[Hash[String, String]],
  "metric"    => Optional[String],
}]

