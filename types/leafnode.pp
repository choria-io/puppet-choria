type Choria::Leafnode = Struct[{
  "url"         => String,
  "account"     => Optional[String],
  "credentials" => Optional[Variant[Stdlib::Absolutepath, String[0, 0]]],
  "tls"         => Optional[Choria::TLS],
}]

