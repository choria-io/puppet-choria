# Manages the `choria-server` service
#
# @private
class choria::service {
  assert_private()

  if $choria::server {
    service{$choria::server_service_name:
      ensure => "running",
      enable => true
    }

    # Since the installation of mcollective plugins are handled in another module at
    # the moment we have to do this ugly hackery here to ensure we restart choria
    # service when new plugins are installed
    #
    # Eventually this module will own installation of plugins and things will improve
    # for now its a bit meh
    Service<| title == "mcollective" |> ~> Service[$choria::server_service_name]

  } else {
    service{$choria::server_service_name:
      ensure => "stopped",
      enable => false
    }
  }
}
