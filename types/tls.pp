type Choria::TLS = Struct[{
  "cert"    => Optional[Variant[Stdlib::Absolutepath, String[0, 0]]],
  "key"     => Optional[Variant[Stdlib::Absolutepath, String[0, 0]]],
  "ca"      => Optional[Variant[Stdlib::Absolutepath, String[0, 0]]],
  "verify"  => Optional[Variant[Boolean, String[0, 0]]],
  "disable" => Optional[Variant[Boolean, String[0, 0]]],
}]
