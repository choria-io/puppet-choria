Puppet::Functions.create_function(:"choria::on_success", Puppet::Functions::InternalFunction) do
  dispatch :handler do
    param "Choria::TaskResults", :results
    block_param
    return_type "Choria::TaskResults"
  end

  def handler(results)
    return results if !results.error_set.empty || results.exception

    yield(results)

    results
  end
end
