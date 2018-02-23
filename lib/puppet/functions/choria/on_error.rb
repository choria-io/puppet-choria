Puppet::Functions.create_function(:"choria::on_error", Puppet::Functions::InternalFunction) do
  dispatch :handler do
    param "Any", :results
    block_param
    return_type "Any"
  end

  def handler(results)
    if results.is_a?(MCollective::Util::BoltSupport::TaskResults) && (results.exception || !results.error_set.empty)
      yield(results)
    end

    results
  end
end
