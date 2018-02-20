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

    loaders = closure_scope.compiler.loaders
    loader = loaders.private_environment_loader

    if loader && (func = loader.load(:plan, playbook))
      result = func.class.dispatcher.dispatchers[0].call_by_name_with_scope(scope, named_args, true)

      return result
    end

    raise(ArgumentError, "Function choria::run_playbook(): Unknown playbook: '%s'" % playbook)
  end
end
