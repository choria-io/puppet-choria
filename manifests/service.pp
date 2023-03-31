# Manages the `choria-server` service
#
# @private
class choria::service {
  assert_private()

  if $choria::manage_service {
    if $choria::server {
      service{$choria::server_service_name:
        ensure => "running",
        enable => $choria::server_service_enable,
      }

      Concat["${choria::config::_config_dir}/policies/groups"] ~> Service[$choria::server_service_name]

      if $choria::manage_mcollective {
        # Ensures that module plugin changes will restart choria
        Mcollective::Module_plugin <| |> ~> Service[$choria::server_service_name]
      }

      # Without this when a mcollective plugin is removed if purge is on the service
      # would not be restarted, unfortunate side effect that a client uninstall will
      # also yield a restart
      File<| tag == "mcollective::plugin_dirs" |> ~> Service[$choria::server_service_name]
    }
  }
}
