type Choria::ScoutCheck = Struct[{
  "arguments"          => Optional[String],
  "builtin"            => Optional[Enum["heartbeat", "goss"]],
  "check_interval"     => Optional[Choria::Duration],
  "ensure"             => Optional[Enum["present", "absent"]],
  "plugin"             => Optional[String],
  "plugin_timeout"     => Optional[Choria::Duration],
  "remediate_command"  => Optional[String],
  "remediate_interval" => Optional[Choria::Duration]
}]
