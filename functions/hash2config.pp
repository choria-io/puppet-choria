# Generates configuration files for mcollective. Keys are sorted alphabetically:
# key = value
function choria::hash2config(Hash $confighash) >> String {
  $result = $confighash.keys.sort.map |$key| {
    sprintf("%s = %s", $key, $confighash[$key])
  }
  ($result << []).join("\n")
}
