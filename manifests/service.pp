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
  } else {
    service{$choria::server_service_name:
      ensure => "stopped",
      enable => false
    }
  }
}
