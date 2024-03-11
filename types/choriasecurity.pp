type Choria::ChoriaSecurity = Struct[{
  "certificate" => Stdlib::Absolutepath,
  "key"         => Stdlib::Absolutepath,
  "token_file"  => Stdlib::Absolutepath,
  "seed_file"   => Stdlib::Absolutepath,
  "ca"          => Optional[Stdlib::Absolutepath],
}]
