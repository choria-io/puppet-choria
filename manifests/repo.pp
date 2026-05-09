# Installs the Choria Package Repositories
#
# @private
class choria::repo (
  Boolean $nightly = false,
  Enum["present", "absent"] $ensure = "present",
) {
  assert_private()

  if $facts["os"]["family"] == "RedHat" {
    $choria_nightly_ensure = $nightly ? {
      true  => "present",
      false => "absent",
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
        mirrorlist => "http://mirrorlists.choria.io/yum/release/el/generic/\$basearch.txt",
        descr      => "Choria Orchestrator Releases",
        gpgkey     => "https://static.choria.io/RELEASE-GPG-KEY";

      "choria_nightly":
        ensure     => $choria_nightly_ensure,
        mirrorlist => "http://mirrorlists.choria.io//yum/nightly/el/generic/\$basearch.txt",
        descr      => "Choria Orchestrator Nightly",
        gpgkey     => "https://static.choria.io/NIGHTLY-GPG-KEY",
    }

  } elsif $facts["os"]["family"] == "Debian" {
    apt::source{"choria-release":
      ensure        => $ensure,
      notify_update => true,
      comment       => "Choria Orchestrator Releases",
      location      => "mirror://mirrorlists.choria.io/apt/generic/mirrors.txt",
      release       => "stable",
      repos         => "main",
      key           => {
        name   => "choria.asc",
        source => "https://static.choria.io/RELEASE-GPG-KEY"
      },
      architecture  => $facts["os"]["architecture"],
      before        => Package[$choria::package_name],
    }

    Class['apt::update'] -> Package[$choria::package_name]
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
