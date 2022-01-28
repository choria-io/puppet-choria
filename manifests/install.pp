# Installs the `choria` package
#
# @private
class choria::install {
  assert_private()

  if $choria::manage_package {
    $version = $choria::ensure ? {
      "present" => $choria::version,
      "absent" => "absent"
    }

    package{$choria::package_name:
      ensure => $version,
      source => $choria::package_source,
    }
  }
}
