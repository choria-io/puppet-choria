# Validates that the input given would be acceptable to a task described by `metadata`
#
# @returns [Boolean]
Puppet::Functions.create_function(:"choria::tasks::validate_input") do
  dispatch :validate do
    param "Hash", :input
    param "Hash", :metadata
  end

  def init
    require_relative "../../../_load_choria"
  end

  def choria
    @_choria ||= begin
       init
       MCollective::Util::Choria.new
    end
  end

  def tasks_support
    @__tasks ||= choria.tasks_support
  end

  def validate(input, metadata)
    ok, reason = tasks_support.validate_task_inputs(input, metadata)

    return true if ok

    raise(reason)
  end
end
