# Downloads metadata for a Puppet Task
#
# This helper downloads the specification of a task from the Puppet Server, for this to work
# you should have followed the configuration guide at [choria.io](https://choria.io) to ensure
# the required Puppet Server configuration were complete
Puppet::Functions.create_function(:"choria::tasks::metadata") do
  dispatch :fetch do
    param "String", :task
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

  def fetch(task)
    tasks_support.task_metadata(task, "production")
  end
end
