# Manages the `choria-server` service
#
# @private
class choria::service_disable {
  assert_private()

  if $choria::manage_service {
    if !$choria::server {
      service{$choria::server_service_name:
        ensure => "stopped",
        enable => false
      }
    }
  }
}

