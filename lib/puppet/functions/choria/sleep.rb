# Sleep for N seconds
Puppet::Functions.create_function(:"choria::sleep") do
  dispatch :do_sleep do
    param "Integer", :seconds
  end

  def do_sleep(seconds)
    sleep(seconds)
  end
end
