# Installs the Choria YUM Repositories
#
# @private
class choria::repo (
  Boolean $nightly = false,
  Enum["present", "absent"] $ensure = "present",
) {
  assert_private()

  if $facts["os"]["family"] == "RedHat" {
    yumrepo{"choria_release":
      ensure          => $ensure,
      baseurl         => 'https://packagecloud.io/choria/release/el/$releasever/$basearch',
      repo_gpgcheck   => true,
      gpgcheck        => false,
      enabled         => true,
      gpgkey          => "https://packagecloud.io/choria/release/gpgkey",
      sslverify       => true,
      sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
      metadata_expire => 300,
    }

    if $nightly {
      yumrepo{"choria_nightly":
        ensure          => $ensure,
        baseurl         => 'https://packagecloud.io/choria/nightly/el/$releasever/$basearch',
        repo_gpgcheck   => true,
        gpgcheck        => false,
        enabled         => true,
        gpgkey          => "https://packagecloud.io/choria/nightly/gpgkey",
        sslverify       => true,
        sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
        metadata_expire => 300,
      }
    }
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
