# Installs the Choria Package Repositories
#
# @private
class choria::repo (
  Boolean $nightly = false,
  Enum["present", "absent"] $ensure = "present",
) {
  assert_private()

  if $facts["os"]["family"] == "RedHat" {
    if ($facts['os']['name'] == 'Amazon' and $facts['os']['release']['major'] == '2') {
      $release = '7'
    } elsif $facts['os']['name'] == 'Fedora' {
      $release = '8'
    } elsif versioncmp($facts['os']['release']['major'], '7') < 0 {
      fail("Choria Repositories are only supported for RHEL/CentOS 7 or newer releases")
    } else {
      $release = '$releasever'
    }

    yumrepo{
      default:
        ensure          => $ensure,
        repo_gpgcheck   => true,
        gpgcheck        => true,
        enabled         => true,
        sslverify       => true,
        baseurl         => absent,
        sslcacert       => "/etc/pki/tls/certs/ca-bundle.crt",
        metadata_expire => 300;

      "choria_release":
        mirrorlist => "http://mirrorlists.choria.io/yum/release/el/${release}/\$basearch.txt",
        descr      => "Choria Orchestrator Releases",
        gpgkey     => "https://choria.io/RELEASE-GPG-KEY";

      "choria_nightly":
        mirrorlist => "http://mirrorlists.choria.io//yum/nightly/el/${release}/\$basearch.txt",
        descr      => "Choria Orchestrator Nightly",
        gpgkey     => "https://choria.io/NIGHTLY-GPG-KEY",
        ensure     => $nightly ? {
          true     => "present",
          false    => "absent"
        }
    }

  } elsif $facts["os"]["family"] == "Debian" {
    $release = $facts["os"]["distro"]["codename"]
    if ! $release in ["xenial", "bionic", "focal", "stretch", "buster", "bullseye"] {
      fail("Choria Repositories are not supported on ${release}")
    }

    $repo_os_name = $facts["os"]["distro"]["id"] ? {
      'Neon'  => 'ubuntu',
      default => $facts["os"]["name"].downcase,
    }

    $_location = sprintf("mirror://mirrorlists.choria.io/apt/release/%s/%s/mirrors.txt", $repo_os_name, $release)

    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => $_location,
      release       => $repo_os_name,
      repos         => $release,
      key           => {
        id     => "3DE1895F7B983F9B22DAF64030BC99C1AAEEF24D",
        source => "https://choria.io/RELEASE-GPG-KEY"
      },
      before        => Package[$choria::package_name],
    }

    Class['apt::update'] -> Package[$choria::package_name]
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
