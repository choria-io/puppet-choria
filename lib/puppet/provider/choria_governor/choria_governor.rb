require "puppet/resource_api/simple_provider"

class Puppet::Provider::ChoriaGovernor::ChoriaGovernor < Puppet::ResourceApi::SimpleProvider
  def get(context)
    run("list", "present")
  end

  def delete(context, name)
    run("delete", "absent", "name" => name)
  end

  def create(context, name, should)
    run("ensure", "present", should)
  end

  def update(context, name, should)
    create(context, name, should)
  end

  def run(action, ens, args={})
    args.delete(:ensure)
    parse_result(Puppet::Util::Execution.execute(make_cmd(action, args), :failonfail => false, :custom_environment => environment), ens)
  end

  def make_cmd(action, args={})
    choria = Puppet::Util.which("choria")
    raise("cannot find choria executable") if choria == ""

    cmd = [choria, "gov", "api", "--%s" % action]
    args.each {|k, v|
      cmd << "--%s" % k
      cmd << v unless v.is_a?(TrueClass)
    }

    cmd.join(" ")
  end

  def parse_result(result, ens)
    if result == ""
      return ""
    end

    parsed = JSON.parse(result, :symbolize_names => true)

    if parsed.is_a?(Hash)
      raise(parsed[:error]) if parsed[:error]

      parsed[:ensure] = ens
    end

    if parsed.is_a?(Array)
      parsed.each {|g| g[:ensure] = ens}
    end

    parsed
  end

  def environment
    user = Etc.getpwuid(Process.euid)

    {
      "USER" => user.name,
      "HOME" => user.dir
    }
  end
end
