# Adds a Scout Metric to gather machine state
#
# @param metric The name to assign to the metric, might be shared with other scout_metrics
# @param command Path to the command to run
# @param arguments Arguments to pass to the command
# @param interval Interval between metric polls in the form 1m, 1h
define choria::scout_metric(
  String $command,
  String $metric = $name,
  String $arguments = "",
  String $interval = "1m",
  Enum["present", "absent"] $ensure = "present"
) {
  choria::machine{"${name}_metric":
    ensure        => $ensure,
    version       => "1.0.0",
    initial_state => "GATHER",
    watchers      => [
      {
        name        => $metric,
        type        => "metric",
        state_match => ["GATHER"],
        properties  => {
          command  => "${command} ${arguments}",
          interval => $interval,
        }
      }
    ],
    transitions   => [
      {
        name        => "MAINTENANCE",
        from        => ["GATHER"],
        destination => "MAINTENANCE"
      },
      {
        name        => "RESUME",
        from        => ["MAINTENANCE"],
        destination => "GATHER"
      }
    ]
  }
}
