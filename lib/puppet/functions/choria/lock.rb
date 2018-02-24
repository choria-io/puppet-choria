# Runs a block of Puppet code within a Choria Data Store Lock
#
# This requires that you have a lockable data store, something like
# consul or etcd
#
# @example run a set of exclusive tasks
#
#    $ds = {
#      "type" => "consul",
#      "timeout" => 120,
#      "ttl" => 60
#    }
#
#    # the code will only execute if the lock is acquired, this way multiple plans
#    # and choria playbooks and indeed anything that can talk to consul across your
#    # entire team can avoid running critical tasks at the same time to avoid corruption
#    # or concurrent modification related failures
#    choria::lock("acme_upgrade", $ds) || {
#      upload_file("/srv/artifacts/acme-${version}.tgz", "/tmp/acme-${version}.tgz", $servers)
#
#      choria_task(
#        "action" => "acme.upgrade",
#        "nodes" => $servers
#      )
#    }
Puppet::Functions.create_function(:"choria::lock", Puppet::Functions::InternalFunction) do
  dispatch :lock do
    scope_param
    param "String", :item
    param "Hash", :properties
    block_param "Callable", :block
  end

  def lock(scope, item, properties, &blk)
    require_relative "../../_load_choria"

    MCollective::Util::BoltSupport.init_choria.data_lock(scope, item, properties, &blk)
  end
end
