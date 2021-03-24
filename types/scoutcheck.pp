type Choria::ScoutCheck = Struct[{
  "arguments"          => Optional[String],
  "builtin"            => Optional[Enum["heartbeat", "goss", "choria_status"]],
  "gossfile"           => Optional[Variant[Stdlib::Absolutepath, String[0, 0]]],
  "check_interval"     => Optional[Choria::Duration],
  "ensure"             => Optional[Enum["present", "absent"]],
  "plugin"             => Optional[String],
  "plugin_timeout"     => Optional[Choria::Duration],
  "properties"         => Optional[Hash[String, Any]],
  "remediate_command"  => Optional[String],
  "remediate_interval" => Optional[Choria::Duration],
  "annotations"        => Optional[Hash[String, String]]
}]
