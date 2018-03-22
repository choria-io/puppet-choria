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
      descr           => 'Choria Orchestrator Releases',
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
        descr           => 'Choria Orchestrator Nightly Builds',
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
  } elsif fact("os.distro.id") == "Ubuntu" {
    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => "https://packagecloud.io/choria/release/ubuntu/",
      release       => "xenial",
      repos         => "main",
      key           => {
        id     => "5921BC1D903D6E0353C985BB9F89253B1E83EA92",
        source => "https://packagecloud.io/choria/release/gpgkey"
      }
    }
  } elsif $facts["os"]["name"] == "Debian" {
    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => "https://packagecloud.io/choria/release/debian/",
      release       => "stretch",
      repos         => "main",
      key           => {
        id     => "5921BC1D903D6E0353C985BB9F89253B1E83EA92",
        source => "https://packagecloud.io/choria/release/gpgkey"
      }
    }
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
