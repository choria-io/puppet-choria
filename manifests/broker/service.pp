# Manages the Choria Broker service
#
# @private
class choria::broker::service {
  assert_private()

  if !$choria::broker::manage_service {
    return()
  }

  $ensure = $choria::ensure ? {
    "present" => "running",
    "absent" => "stopped"
  }

  $enabled = $choria::ensure ? {
    "present" => true,
    "absent" => false
  }

  service{$choria::broker_service_name:
    ensure  => $ensure,
    enable  => $enabled,
    require => Class["choria::install"]
  }
}
