type Choria::ScoutMetric = Struct[{
  "command"   => String,
  "metric"    => Optional[String],
  "arguments" => Optional[String],
  "interval"  => Optional[Choria::Duration],
  "ensure"    => Optional[Enum["present", "absent"]],
}]

