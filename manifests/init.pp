# @param manage_package_repo Installs the package repositories
# @param nightly_repo Install the nightly package repo as well as the release one
# @param ensure Add or remove the software
class choria (
  Bool $manage_package_repo = false,
  Bool $nightly_repo = false,
  Enum["present", "absent"] $ensure = "present",
) {
  if $manage_package_repo {
    class{"choria::repo":
      nightly => $nightly_repo,
      ensure  => $ensure
    }
  }
}
