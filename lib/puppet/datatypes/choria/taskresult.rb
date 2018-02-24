Puppet::DataTypes.create_type("Choria::TaskResult") do
  interface <<-PUPPET
    attributes => {
      "host" => Choria::Node,
      "result" => Hash[String[1], Data]
    },
    functions => {
      error => Callable[[], Optional[Error]],
      ok => Callable[[], Boolean],
      fail_ok => Callable[[], Boolean],
      type => Callable[[], String[1]],
      "[]" => Callable[[String[1]], Data],
      "value" => Callable[[], Data]
    }
  PUPPET

  require_relative "../../_load_choria"

  implementation_class MCollective::Util::BoltSupport::TaskResult
end
