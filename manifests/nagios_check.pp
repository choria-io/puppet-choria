# Adds a Choria Autonomous Agent to check machine health
#
# @param plugin Path to the plugin to run
# @param arguments Arguments to pass to the plugin
# @param plugin_timeout How long the plugin is allowed to run
# @param check_interval Interval between checks in the form 1m, 1h
# @param remediate_command Command to run to remediate failures
# @param remediate_states What states the remediation command should be run in
# @param remediate_interval Interval between remediation attempts
define choria::nagios_check(
  String $plugin,
  String $arguments = "",
  String $plugin_timeout = "10s",
  String $check_interval = "5m",
  String $remediate_command = "",
  Array[String] $remediate_states = ["CRITICAL"],
  String $remediate_interval = "15m"
) {
  if !("plugin.choria.machine.store" in $choria::server_config) {
    fail("Cannot configure choria::nagios_check ${name}, plugin.choria.machine.store is not set")
  }

  $_store = $choria::server_config["plugin.choria.machine.store"]

  $_base_machine = {
    name          => $name,
    version       => "1.0.0",
    initial_state => "UNKNOWN",
    splay_start   => 300,
    transitions   => [
      {
        name        => "UNKNOWN",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "UNKNOWN"
      },
      {
        name        => "OK",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "OK"
      },
      {
        name        => "WARNING",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "WARNING"
      },
      {
        name        => "CRITICAL",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "CRITICAL"
      },
      {
        name        => "MAINTENANCE",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "MAINTENANCE"
      },
      {
        name        => "RESUME",
        from        => ["MAINTENANCE"],
        destination => "UNKNOWN"
      }
    ]
  }

  $_base_watchers = [
      {
        name        => "check",
        type        => "nagios",
        interval    => $check_interval,
        state_match => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        properties  => {
          plugin    => "${plugin} ${arguments}",
          timeout   => $plugin_timeout,
        }
      }
  ]

  if $remediate_command != "" and $remediate_states.length > 0{
    $_remediate_watcher = {
      name               => "remediate",
      type               => "exec",
      state_match        => $remediate_states,
      interval           => $remediate_interval,
      success_transition => "UNKNOWN",
      properties         => {
        command          => $remediate_command
      }
    }
  } else {
    $_remediate_watcher = {}
  }

  $_watchers = $_base_watchers + [$_remediate_watcher]
  $_machine = $_base_machine + {watchers => $_watchers}

  file{"${_store}/${name}":
    ensure => directory,
    owner  => $choria::config_user,
    group  => $choria::config_group,
    mode   => "0755",
  }

  file{"${_store}/${name}/machine.yaml":
    content => $_machine.to_yaml,
    owner   => $choria::config_user,
    group   => $choria::config_group,
    mode    => "0644",
  }
}
