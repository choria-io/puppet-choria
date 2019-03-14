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
      baseurl         => "${choria::repo_baseurl}/release/el/\$releasever/\$basearch",
      repo_gpgcheck   => false,
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
        baseurl         => "${choria::repo_baseurl}/nightly/el/\$releasever/\$basearch",
        repo_gpgcheck   => false,
        gpgcheck        => false,
        enabled         => true,
        gpgkey          => "https://packagecloud.io/choria/nightly/gpgkey",
        sslverify       => true,
        sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
        metadata_expire => 300,
      }
    }
  } elsif $facts["os"]["name"] == "Ubuntu" {
    if versioncmp($facts['os']['release']['major'], '16.04') < 0 {
      fail("Choria Repositories are only supported for xenial or newer releases")
    } elsif versioncmp($facts['os']['release']['major'], '17.10') > 0 {
      $release = 'bionic'
    } else {
      $release = 'xenial'
    }
    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => "${choria::repo_baseurl}/release/ubuntu/",
      release       => $release,
      repos         => "main",
      key           => {
        id     => "5921BC1D903D6E0353C985BB9F89253B1E83EA92",
        source => "https://packagecloud.io/choria/release/gpgkey"
      },
      before        => Package[$choria::package_name],
    }
  } elsif $facts["os"]["name"] == "Debian" {
    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => "${choria::repo_baseurl}/release/debian/",
      release       => "stretch",
      repos         => "main",
      key           => {
        id     => "5921BC1D903D6E0353C985BB9F89253B1E83EA92",
        source => "https://packagecloud.io/choria/release/gpgkey"
      },
      before        => Package[$choria::package_name],
    }
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
