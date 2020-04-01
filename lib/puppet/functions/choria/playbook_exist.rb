# Checks if the Choria playbook present
#
# This function tries to load Choria playbook and returns true if playbook
# exists (regardless can it be parsed or not). False is returned otherwise.
#
# @example check 'example::restart_puppet' playbook exists
#
#    choria::playbook_exist("example::restart_puppet")
#
Puppet::Functions.create_function(:"choria::playbook_exist", Puppet::Functions::InternalFunction) do
  dispatch :playbook_exist do
    scope_param
    param "String", :playbook
  end

  def playbook_exist(scope, playbook)
    unless Puppet[:tasks]
      raise Puppet::ParseErrorWithIssue.from_issue_and_stack(
        Puppet::Pops::Issues::TASK_OPERATION_NOT_SUPPORTED_WHEN_COMPILING, operation: "playbook_exist"
      )
    end

    loaders = closure_scope.compiler.loaders
    loader = loaders.private_environment_loader

    begin
      if loader && (func = loader.load(:plan, playbook))
        return true
      end
    rescue ArgumentError, Puppet::Error
      return true  # Return true if not parseable too (as it exists)
    end

    false
  end
end
