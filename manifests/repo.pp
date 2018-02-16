class choria::repo(
  Boolean $nightly = false,
  Enum["present", "absent"] $ensure = "present"
) {
  if $facts["os"]["family"] == "RedHat" {
    yumrepo{"choria_release":
      baseurl         => 'https://packagecloud.io/choria/release/el/$releasever/$basearch',
      repo_gpgcheck   => true,
      gpgcheck        => false,
      enabled         => true,
      gpgkey          => "https://packagecloud.io/choria/release/gpgkey",
      sslverify       => true,
      sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
      metadata_expire => 300,
      ensure          => $ensure
    }

    if $nightly {
      yumrepo{"choria_nightly":
        baseurl         => 'https://packagecloud.io/choria/nightly/el/$releasever/$basearch',
        repo_gpgcheck   => true,
        gpgcheck        => false,
        enabled         => true,
        gpgkey          => "https://packagecloud.io/choria/nightly/gpgkey",
        sslverify       => true,
        sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
        metadata_expire => 300,
        ensure          => $ensure
      }
    }
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
