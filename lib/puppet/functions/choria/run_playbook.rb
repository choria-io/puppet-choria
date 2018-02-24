# Runs a Choria playbook
#
# This helper invokes a Choria Playbook and returns any result that the called Playbook returns
#
# Errors will by default be raised causing execution to fail, passing `__catch_errors => true` as
# a property will return the failing task result
#
# @example runs a playbook, fails on any failure
#
#    choria::run_playbook("example::restart_puppet",
#      "cluster" => "alpha"
#    )
#
# @example runs a playbook with custom error handling
#
#    choria::run_playbook("example::restart_puppet", _catch_errors => true,
#      "cluster" => "alpha"
#    )
#      .on_error |$err| {
#         choria::run_playbook("example::notify_slack",
#           "msg" => sprintf("Playbook %s failed: %s", $facts["choria"]["playbook"], $err.message)
#         )
#         choria::run_playbook("example::enable_puppet", "cluster" => "alpha" )
#         fail($err.message)
#       }
Puppet::Functions.create_function(:"choria::run_playbook", Puppet::Functions::InternalFunction) do
  dispatch :run_playbook do
    scope_param
    param "String", :playbook
    optional_param "Hash", :named_args
  end

  def run_playbook(scope, playbook, named_args = {})
    unless Puppet[:tasks]
      raise Puppet::ParseErrorWithIssue.from_issue_and_stack(
        Puppet::Pops::Issues::TASK_OPERATION_NOT_SUPPORTED_WHEN_COMPILING, operation: "run_playbook"
      )
    end

    args = named_args.reject {|a| a.start_with?("_") }
    result = []

    begin
      loaders = closure_scope.compiler.loaders
      loader = loaders.private_environment_loader

      if loader && (func = loader.load(:plan, playbook))
        results = func.class.dispatcher.dispatchers[0].call_by_name_with_scope(scope, args, true)
        return results
      end
    rescue Puppet::Error
      raise unless named_args["_catch_errors"]

      return MCollective::Util::BoltSupport::TaskResults.new([], $!)
    end

    raise(ArgumentError, "Function choria::run_playbook(): Unknown playbook: '%s'" % playbook)
  end
end
