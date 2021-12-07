# Adds a series of choria_kv_bucket resources
#
# @private
class choria::kv_buckets {
  assert_private()

  require(Class["choria::config"])

  $choria::kv_buckets.each |$bucket, $properties| {
    choria_kv_bucket{$bucket:
      * => $properties
    }
  }
}
