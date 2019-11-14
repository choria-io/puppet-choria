# Installs, configures and manages the Choria Orchestrator
#
# @param manage_package_repo Installs the package repositories
# @param nightly_repo Install the nightly package repo as well as the release one
# @param ensure Add or remove the software
# @param repo_baseurl Used to override default packagecloud package source
# @param version The version of Choria to install
# @param mcollective_config_dir Directory where mcollective configuration is stored
# @param broker_config_file The configuration file for the broker
# @param server_config_file The configuration file for the server
# @param logfile The default file to log to
# @param broker_logfile The file to log the broker to
# @param server_logfile The file to log the server to
# @param statusfile The file to write server status to
# @param status_write_interval How often the status file should be written in seconds
# @param log_level The default logging level to use
# @param broker_log_level The logging level to use for the broker
# @param server_log_level The logging level to use for the server
# @param rubypath Path to the Ruby installation used for the MCollective compatibility shims
# @param srvdomain The domain name to use when doing SRV lookups
# @param package_name The package to install
# @param broker_service_name The service name of the Choria Broker
# @param server_service_name The service name of the Choria Server
# @param identity The identity this server will use to determine SSL cert names etc
# @param server To enable or disable the choria server
# @param server_config Configuration for the Choria Server
# @param repo_gpgcheck Whether to enable repo gpgcheck (must be false for packagecloud mirrors)
class choria (
  Boolean $manage_package_repo ,
  Boolean $nightly_repo,
  Enum["present", "absent"] $ensure,
  String $repo_baseurl,
  String $version,
  Enum[debug, info, warn, error, fatal] $log_level,
  Optional[String] $srvdomain,
  Stdlib::Compat::Absolute_path $mcollective_config_dir,
  Stdlib::Compat::Absolute_path $broker_config_file,
  Stdlib::Compat::Absolute_path $server_config_file,
  Stdlib::Compat::Absolute_path $logfile,
  Optional[Stdlib::Compat::Absolute_path] $statusfile,
  Integer $status_write_interval,
  Stdlib::Compat::Absolute_path $rubypath,
  String $package_name,
  String $broker_service_name,
  String $server_service_name,
  String $identity,
  Boolean $server,
  Hash $server_config,
  String $root_group,
  Boolean $repo_gpgcheck,
  Enum[debug, info, warn, error, fatal] $broker_log_level = $log_level,
  Enum[debug, info, warn, error, fatal] $server_log_level = $log_level,
  Stdlib::Compat::Absolute_path $broker_logfile = $logfile,
  Stdlib::Compat::Absolute_path $server_logfile = $logfile,
) {
  if $manage_package_repo {
    class{"choria::repo":
      nightly       => $nightly_repo,
      repo_gpgcheck => $repo_gpgcheck,
      ensure        => $ensure,
      before        => Class["choria::install"]
    }
  }

  class{"choria::install": }
  -> class{"choria::config": }
  -> class{"choria::service": }

  contain choria::install
  contain choria::service
}
