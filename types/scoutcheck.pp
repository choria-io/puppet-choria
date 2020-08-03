type Choria::ScoutCheck = Struct[{
  "arguments"          => Optional[String],
  "builtin"            => Optional[Enum["heartbeat", "goss"]],
  "gossfile"           => Optional[Variant[Stdlib::Compat::Absolute_path, String[0, 0]]],
  "check_interval"     => Optional[Choria::Duration],
  "ensure"             => Optional[Enum["present", "absent"]],
  "plugin"             => Optional[String],
  "plugin_timeout"     => Optional[Choria::Duration],
  "remediate_command"  => Optional[String],
  "remediate_interval" => Optional[Choria::Duration],
  "annotations"        => Optional[Hash[String, String]]
}]
