# Generates configuration files for mcollective. Keys are sorted alphabetically:
# key = value
function choria::hash2config(Hash $confighash) >> String {
  $result = $confighash.keys.sort.map |$key| {
    $val = $confighash[$key]

    if $val =~ Array {
      $val.each |$item| {
        unless $item =~ Integer or $item =~ Float or $item =~ String {
          fail("Array values are only supported for Integer, Float or String data types")
        }
      }

      sprintf("%s = %s", $key, $val.join(", "))
    } else {
      sprintf("%s = %s", $key, $val)
    }
  }
  ($result << []).join("\n")
}
