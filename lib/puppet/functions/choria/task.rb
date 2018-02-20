# Execute Choria Playbook Tasks
#
# Any task supported by Choria Playbooks is supported and
# can be used from within a plan, though there is probably
# not much sense in using the Bolt task type as you can just
# use `run_task` or `run_command` directly in the plan.
#
# The options to Playbook tasks like `pre_book`, `on_success`,
# `on_fail` and `post_book` does not make sense within the
# Puppet Plan DSL.
#
# @example disables puppet and wait for all nodes to idle
#
# ~~~ puppet
# choria::task("mcollective",
#   "action" => "puppet.disable",
#   "nodes" => $all_nodes,
#   "properties" => {
#     "message" => "disabled during plan execution ${name}"
#   }
# )
#
# $result = choria::task("mcollective",
#   "action" => "puppet.status",
#   "nodes" => $all_nodes,
#   "assert" => "idling=true",
#   "tries" => 10,
#   "try_sleep" => 30
# )
#
# if $result.ok {
#   choria::task("slack",
#     "token" => $slack_token,
#     "channel" = "#ops",
#     "text" => "All nodes have been disabled and are idling"
#   )
# }
# ~~~
Puppet::Functions.create_function(:"choria::task") do
  dispatch :run_task do
    param "String", :type
    param "Hash", :properties
    return_type "Choria::TaskResults"
  end

  dispatch :run_mcollective_task do
    param "Hash", :properties
    return_type "Choria::TaskResults"
  end

  def run_mcollective_task(properties)
    run_task("mcollective", properties)
  end

  def run_task(type, properties)
    require_relative "../../_load_choria"

    results = MCollective::Util::BoltSupport.init_choria.run_task(type, properties).map do |node, properties|
      MCollective::Util::BoltSupport::TaskResult.new(node, properties)
    end

    MCollective::Util::BoltSupport::TaskResults.new(results)
  end
end
