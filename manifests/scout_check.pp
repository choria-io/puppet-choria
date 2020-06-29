# Adds a Choria Autonomous Agent to check machine health
#
# @param plugin Path to the plugin to run
# @param arguments Arguments to pass to the plugin
# @param plugin_timeout How long the plugin is allowed to run
# @param check_interval Interval between checks in the form 1m, 1h
# @param remediate_command Command to run to remediate failures
# @param remediate_states What states the remediation command should be run in
# @param remediate_interval Interval between remediation attempts
define choria::scout_check(
  String $plugin,
  String $arguments = "",
  String $plugin_timeout = "10s",
  String $check_interval = "5m",
  String $remediate_command = "",
  Array[String] $remediate_states = ["CRITICAL"],
  String $remediate_interval = "15m",
  Enum["present", "absent"] $ensure = "present"
) {
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

  if $remediate_command != "" and $remediate_states.length > 0 {
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

    $_watchers = $_base_watchers + [$_remediate_watcher]
  } else {
    $_watchers = $_base_watchers
  }

  choria::machine{$name:
    version       => "1.0.0",
    initial_state => "UNKNOWN",
    watchers      => $_watchers,
    transitions   => [
      {
        name        => "UNKNOWN",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL", "FORCE_CHECK"],
        destination => "UNKNOWN"
      },
      {
        name        => "OK",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL", "FORCE_CHECK"],
        destination => "OK"
      },
      {
        name        => "WARNING",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL", "FORCE_CHECK"],
        destination => "WARNING"
      },
      {
        name        => "CRITICAL",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL", "FORCE_CHECK"],
        destination => "CRITICAL"
      },
      {
        name        => "FORCE_CHECK",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL"],
        destination => "FORCE_CHECK"
      },
      {
        name        => "MAINTENANCE",
        from        => ["UNKNOWN", "OK", "WARNING", "CRITICAL", "FORCE_CHECK"],
        destination => "MAINTENANCE"
      },
      {
        name        => "RESUME",
        from        => ["MAINTENANCE"],
        destination => "FORCE_CHECK"
      }
    ]
  }
}
