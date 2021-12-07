# Adds a series of choria_governor resources
#
# @private
class choria::governors {
  assert_private()

  require(Class["choria::config"])

  $choria::governors.each |$governor, $properties| {
    choria_governor{$governor:
      * => $properties
    }
  }
}

