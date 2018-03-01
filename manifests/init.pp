# Installs, configures and manages the Choria Orchestrator
#
# @param manage_package_repo Installs the package repositories
# @param nightly_repo Install the nightly package repo as well as the release one
# @param ensure Add or remove the software
# @param version The version of Choria to install
# @param broker_config The configuration file for the broker
# @param logfile The file to log to
# @param loglevel The logging level to use
class choria (
  Boolean $manage_package_repo = false,
  Boolean $nightly_repo = false,
  Enum["present", "absent"] $ensure = "present",
  String $version = "present",
  Stdlib::Compat::Absolute_path $broker_config = "/etc/choria/broker.cfg",
  Stdlib::Compat::Absolute_path $log_file = "/var/log/choria.log",
  Enum[debug, info, warn, error, fatal] $log_level = "warn"
) {
  if $manage_package_repo {
    class{"choria::repo":
      nightly => $nightly_repo,
      ensure  => $ensure,
      before  => Class["choria::install"]
    }
  }

  contain choria::install
}
