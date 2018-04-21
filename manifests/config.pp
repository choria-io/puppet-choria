# Configures the Choria Server
#
# @private
class choria::config {
  assert_private()

  $defaults = {
    "collectives" => "mcollective"
  }

  $config = $defaults + $choria::server_config + {
    "logfile"                    => $choria::log_file,
    "loglevel"                   => $choria::log_level,
    "identity"                   => $choria::identity,
    "plugin.choria.srv_domain"   => $choria::srvdomain,
  }

  if "plugin.choria.agent_provider.mcorpc.agent_shim" in $choria::server_config  and "plugin.choria.agent_provider.mcorpc.config" in $choria::server_config {
    file{$choria::server_config["plugin.choria.agent_provider.mcorpc.agent_shim"]:
      owner   => "root",
      group   => $choria::root_group,
      mode    => "0755",
      content => epp("choria/choria_mcollective_agent_compat.rb.epp")
    }
  }

  file{$choria::server_config_file:
    owner   => "root",
    group   => $choria::root_group,
    mode    => "0640",
    content => mcollective::hash2config($config),
    notify  => Class["choria::service"],
    require => Class["choria::install"]
  }
}

