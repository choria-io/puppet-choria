# Installs, configures and manages the Choria Orchestrator
#
# @param manage_package_repo Installs the package repositories
# @param nightly_repo Install the nightly package repo as well as the release one
# @param ensure Add or remove the software
# @param version The version of Choria to install
# @param broker_config_file The configuration file for the broker
# @param server_config_file The configuration file for the server
# @param logfile The file to log to
# @param loglevel The logging level to use
# @param rubypath Path to the Ruby installation used for the MCollective compatability shims
# @param srvdomain The domain name to use when doing SRV lookups
# @param package_name The package to install
# @param broker_service_name The service name of the Choria Broker
# @param server_service_name The service name of the Choria Server
# @param identity The identity this server will use to determine SSL cert names etc
# @param server To enable or disable the choria server
# @param server_config Configuration for the Choria Server
class choria (
  Boolean $manage_package_repo ,
  Boolean $nightly_repo,
  Enum["present", "absent"] $ensure,
  String $version,
  Enum[debug, info, warn, error, fatal] $log_level,
  Optional[String] $srvdomain,
  Stdlib::Compat::Absolute_path $broker_config_file,
  Stdlib::Compat::Absolute_path $server_config_file,
  Stdlib::Compat::Absolute_path $log_file,
  Stdlib::Compat::Absolute_path $rubypath,
  String $package_name,
  String $broker_service_name,
  String $server_service_name,
  String $identity,
  Boolean $server,
  Hash $server_config,
  String $root_group,
) {
  if $manage_package_repo {
    class{"choria::repo":
      nightly => $nightly_repo,
      ensure  => $ensure,
      before  => Class["choria::install"]
    }
  }

  class{"choria::install": }
  -> class{"choria::config": }
  -> class{"choria::service": }

  contain choria::install
  contain choria::service
}
