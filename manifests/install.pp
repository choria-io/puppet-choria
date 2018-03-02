# Installs the `choria` package
#
# @private
class choria::install {
  assert_private()

  $version = $choria::ensure ? {
    "present" => $choria::version,
    "absent" => "absent"
  }

  package{$choria::package_name:
    ensure => $version
  }
}
