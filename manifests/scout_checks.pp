# Adds a series of Scout Checks, ideal for use via Hiera
#
# @private
class choria::scout_checks {
  assert_private()

  $choria::scout_checks.each |$check, $properties| {
    choria::scout_check{$check:
      * => $properties
    }
  }
}
