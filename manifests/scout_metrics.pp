# Adds a series of Scout Metrics, ideal for use via Hiera
#
# @private
class choria::scout_metrics {
  assert_private()

  $choria::scout_metrics.each |$metric, $properties| {
    choria::scout_metric{$metric:
      * => $properties
    }
  }
}
