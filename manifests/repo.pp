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
        mirrorlist => "http://mirrorlists.choria.io/yum/release/el/${release}/\$basearch.txt",
        descr      => "Choria Orchestrator Releases",
        gpgkey     => "https://choria.io/RELEASE-GPG-KEY";

      "choria_nightly":
        ensure     => $choria_nightly_ensure,
        mirrorlist => "http://mirrorlists.choria.io//yum/nightly/el/${release}/\$basearch.txt",
        descr      => "Choria Orchestrator Nightly",
        gpgkey     => "https://choria.io/NIGHTLY-GPG-KEY",
    }

  } elsif $facts["os"]["family"] == "Debian" {
    $release = $facts["os"]["distro"]["codename"] ? {
      # Map Linux Mint codenames to the corresponding Ubuntu ones.
      # Note: we do not use this mapped OS, that these mappings are provided by the community on a best effort basis.
      # Feel free to send PR to add new release when necessary.
      'tara'   => 'bionic',
      'tessa'  => 'bionic',
      'tina'   => 'bionic',
      'tricia' => 'bionic',
      'ulyana' => 'focal',
      'ulyssa' => 'focal',
      'uma'    => 'focal',
      'una'    => 'focal',

      # Use the actual codename in all other cases
      default  => $facts["os"]["distro"]["codename"],
    }

    if ! $release in ["xenial", "bionic", "focal", "stretch", "buster", "bullseye"] {
      fail("Choria Repositories are not supported on ${release}")
    }

    $repo_os_name = $facts["os"]["distro"]["id"] ? {
      'Neon'      => 'ubuntu',
      'linuxmint' => 'ubuntu',
      default     => $facts["os"]["name"].downcase,
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
        name   => "choria.asc",
        source => "https://choria.io/RELEASE-GPG-KEY"
      },
      architecture  => $facts["os"]["architecture"],
      before        => Package[$choria::package_name],
    }

    Class['apt::update'] -> Package[$choria::package_name]
  } else {
    fail(sprintf("Choria Repositories are not supported on %s", $facts["os"]["family"]))
  }
}
