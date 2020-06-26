# Installs the Choria YUM Repositories
#
# @private
class choria::repo (
  Boolean $nightly = false,
  Enum["present", "absent"] $ensure = "present",
) {
  assert_private()
  $nightly_ensure = $nightly ? {
    true  => "present",
    false => "absent",
  }

  if $facts["os"]["family"] == "RedHat" {
    if ($facts['os']['name'] == 'Amazon' and $facts['os']['release']['major'] == '2') {
      $release = '7'
    } elsif $facts['os']['name'] == 'Amazon' {
      $release = '6'
    } elsif versioncmp($facts['os']['release']['major'], '6') < 0 {
      fail("Choria Repositories are only supported for RHEL/CentOS 6 or newer releases")
    } elsif versioncmp($facts['os']['release']['major'], '7') > 0 {
      $release = '7'
    } else {
      $release = '$releasever'
    }
    yumrepo{"choria_release":
      ensure          => $ensure,
      descr           => 'Choria Orchestrator Releases',
      baseurl         => "${choria::repo_baseurl}/release/el/${release}/\$basearch",
      repo_gpgcheck   => $choria::repo_gpgcheck,
      gpgcheck        => false,
      enabled         => true,
      gpgkey          => "https://packagecloud.io/choria/release/gpgkey",
      sslverify       => true,
      sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
      metadata_expire => 300,
    }

    yumrepo{"choria_nightly":
      ensure          => $nightly_ensure,
      descr           => 'Choria Orchestrator Nightly Builds',
      baseurl         => "${choria::repo_baseurl}/nightly/el/${release}/\$basearch",
      repo_gpgcheck   => $choria::repo_gpgcheck,
      gpgcheck        => false,
      enabled         => true,
      gpgkey          => "https://packagecloud.io/choria/nightly/gpgkey",
      sslverify       => true,
      sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
      metadata_expire => 300,
    }
  } elsif $facts["os"]["family"] == "Debian" {
    $release = $facts["os"]["distro"]["codename"]
    if ! $release in ["xenial", "bionic", "stretch", "buster"] {
      fail("Choria Repositories are not supported on ${release}")
    }

    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => sprintf("%s/release/%s/", $choria::repo_baseurl, $facts["os"]["name"].downcase),
      release       => $release,
      repos         => "main",
      key           => {
        id     => "5921BC1D903D6E0353C985BB9F89253B1E83EA92",
        source => "https://packagecloud.io/choria/release/gpgkey"
      },
      before        => Package[$choria::package_name],
    }

    apt::source{"choria-nightly":
      ensure        => $nightly_ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Nightly Builds",
      location      => sprintf("%s/nightly/%s/", $choria::repo_baseurl, $facts["os"]["name"].downcase),
      release       => $release,
      repos         => "main",
      key           => {
        id     => "3F311BDCBDFBF9A775FD6FB16C3AD4D617CE1A26",
        source => "https://packagecloud.io/choria/nightly/gpgkey"
      },
      before        => Package[$choria::package_name],
    }

    Class['apt::update'] -> Package[$choria::package_name]
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
