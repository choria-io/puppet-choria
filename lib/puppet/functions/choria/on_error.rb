# Handles errors contained in Choria::TaskResults
#
# This is a helper to create error handlers for plans and tasks that returns Choria::TaskResults,
# it's primarily aimed to be used in long playbooks with many tasks being run where creating many
# uniquely named result variables is tedious.
#
# The lamba will only be called when the result is a Choria::TaskResults instance and if there
# were exceptions or when error_set is empty.  This means tasks with `fail_ok` set to true will
# still trigger this handler.
#
# Non Choria::TaskResults will simply result in this lambda never being called
#
# This function returns the result so it can be chained with other `on_error` or `on_success`
# calls and will return the results from the plan if it's the last statement in the plan.
#
# @example invoke a task and handle results without temporary variables
#
#    choria::task("mcollective", _catch_errors => true,
#       "action" => "rpcutil.ping",
#       "nodes" => $nodes
#    )
#     .on_error |$err| {
#       choria::run_playbook("example::rollback")
#     }
#
#     .on_success |$succ| {
#       choria::run_playbook("example::notifier", "progress" => "Step ping completed succesfully")
#     }
#
# @example invoke a task and handle errors with temporary variables
#
#    $result choria::task("mcollective", _catch_errors => true,
#       "action" => "rpcutil.ping",
#       "nodes" => $nodes
#    )
#
#    $result.on_error |$err| {
#       choria::run_playbook("example::rollback")
#    }
#
# @param results [Any] The result set to process as an error
# @return [Any] The data that was passed in
Puppet::Functions.create_function(:"choria::on_error", Puppet::Functions::InternalFunction) do
  dispatch :handler do
    param "Any", :results
    block_param
    return_type "Any"
  end

  def handler(results)
    if results.is_a?(MCollective::Util::BoltSupport::TaskResults) && (!results.error_set.empty || results.exception)
      yield(results)
    end

    results
  end
end
