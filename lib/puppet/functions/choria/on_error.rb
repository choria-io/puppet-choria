Puppet::Functions.create_function(:"choria::on_error", Puppet::Functions::InternalFunction) do
  dispatch :handler do
    param "Choria::TaskResults", :results
    block_param
    return_type "Choria::TaskResults"
  end

  def handler(results)
    yield(results) if results.exception || !results.error_set.empty

    results
  end
end
