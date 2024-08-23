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
    parse_result(Puppet::Util::Execution.execute(make_cmd(action, args), :failonfail => true, :custom_environment => environment), ens)
  end

  def config_file
    paths = if Process.uid == 0
      [
        "/etc/choria/puppet.conf",
        "/etc/choria/server.conf",
        "/usr/local/etc/choria/puppet.conf",
        "/usr/local/etc/choria/server.conf",
      ]
    else
      [
        "/etc/choria/puppet.conf",
        "/etc/choria/client.conf",
        "/usr/local/etc/choria/puppet.conf",
        "/usr/local/etc/choria/client.conf",
      ]
    end

    paths.each do |p|
      return p if File.exist?(p)
    end

    raise("cannot find configuration path")
  end

  def make_cmd(action, args={})
    choria = Puppet::Util.which("choria")
    raise("cannot find choria executable") if choria == ""

    cmd = [choria, "governor", "api", "--%s" % action, "--config=%s" % config_file]

    args.each do |k, v|
      k = k.to_s.gsub("_", "-")
      if v.is_a?(TrueClass)
        cmd << "--%s" % k
      elsif v.is_a?(FalseClass)
        cmd << "--no-%s" % k
      else
        cmd << "--%s=%s" % [k, v]
      end
    end

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
