# Discovers nodes using Choria Playbook Node Seets
#
# Any Node Set that Choria Playbooks support can be used
# to discover nodes, test their Choria availability and
# audit their agents
#
# @example discover using mcollective
#
#    # Discovers machines using apache in the UK
#    # test their reachability over mcollective and
#    # ensure they have the puppet agent is newer than
#    # version 1.2.3
#    $nodes = choria::discover("mcollective",
#      "classes" => ["apache"],
#      "facts" => ["country=uk"],
#      "test" => true,
#      "uses" => ["puppet" => ">= 1.2.3"]
#    )
#
# @example discover using terraform outputs
#
#    $nodes = choria::discover("terraform",
#      "statefile" => "/path/to/terraform.tfstate",
#      "output" => "webservers"
#    )
#
# @example perform PQL queries
#
#    $nodes = choria::discover("pql",
#       "query" => "facts { name = 'country' and value = '${country}' }"
#    )
#
# @example mcollective discovery shortcut
#
#    # On the assumption that mcollective discovery will be
#    # used most there is a shortcut
#    $nodes = choria::discover(
#      "classes" => ["apache"],
#      "facts" => ["country=uk"],
#      "test" => true,
#      "uses" => ["puppet" => ">= 1.2.3"]
#    )
Puppet::Functions.create_function(:"choria::discover", Puppet::Functions::InternalFunction) do
  dispatch :mcollective_discover do
    scope_param
    param "Hash", :options
  end

  dispatch :discover do
    scope_param
    param "String", :type
    param "Hash", :options
  end

  def mcollective_discover(scope, options)
    discover(scope, "mcollective", options)
  end

  def discover(scope, type, options)
    require_relative "../../_load_choria"

    MCollective::Util::BoltSupport.init_choria.discover_nodes(scope, type, options)
  end
end

