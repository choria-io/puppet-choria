# Adds a Choria Autonomous Agent
#
# @param initial_state The initial state the FSM starts in
# @param version The SemVer version string for this agent
# @param transitions The supported transition events
# @param watchers The watchers to run in specific states
define choria::machine(
  String $initial_state,
  String $version,
  Array[Hash] $transitions,
  Array[Hash] $watchers,
  Enum["present", "absent"] $ensure = "present",
) {
  if !("plugin.choria.machine.store" in $choria::server_config) {
    fail("Cannot configure choria::machine ${name}, plugin.choria.machine.store is not set")
  }

  $_store = $choria::server_config["plugin.choria.machine.store"]

  $_machine = {
    name          => $name,
    version       => $version,
    initial_state => $initial_state,
    transitions   => $transitions,
    watchers      => $watchers
  }

  $_dir_ensure = $ensure ? {"present" => directory, "absent" => "absent"}

  file{"${_store}/${name}":
    ensure => $_dir_ensure,
    owner  => $choria::config_user,
    group  => $choria::config_group,
    mode   => "0755",
  }

  file{"${_store}/${name}/machine.yaml":
    ensure  => $ensure,
    content => $_machine.to_yaml,
    owner   => $choria::config_user,
    group   => $choria::config_group,
    mode    => "0644",
  }
}
