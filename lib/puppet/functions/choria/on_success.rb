Puppet::Functions.create_function(:"choria::on_success", Puppet::Functions::InternalFunction) do
  dispatch :handler do
    param "Choria::TaskResults", :results
    block_param
    return_type "Choria::TaskResults"
  end

  def handler(results)
    if results.is_a?(MCollective::Util::BoltSupport::TaskResults) && (!results.error_set.empty || results.exception)
      yield(results)
    end

    results
  end
end
