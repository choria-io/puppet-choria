# @summary Configure a choria group
#
# @example Basic group definitions
#
#   choria::group { 'blue':
#     members => [
#       'choria=alice.mcollective',
#       'choria=bob.mcollective',
#     ],
#   }
#
#   choria::group { 'red':
#     members => [
#       'choria=eve.mcollective',
#     ],
#   }
#
# @param members
#   The list of members of the group
define choria::group (
  Array[String[1]] $members,
) {
  include choria

  concat::fragment{"choria-policies-groups-${name}":
    target  => "${choria::config::_config_dir}/policies/groups",
    content => "${name} ${members.join(' ')}\n",
    order   => "01",
  }
}
