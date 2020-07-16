# Configures the Choria Server
#
# @private
class choria::config {
  assert_private()

  $defaults = {
    "collectives" => "mcollective"
  }

  if $choria::statusfile {
    $status = {
      "plugin.choria.status_file_path"       => $choria::statusfile,
      "plugin.choria.status_update_interval" => $choria::status_write_interval
    }
  } else {
    $status = {}
  }

  $config = $defaults + $choria::server_config + $status + {
    "logfile"                    => $choria::server_logfile,
    "loglevel"                   => $choria::server_log_level,
    "identity"                   => $choria::identity,
    "plugin.choria.srv_domain"   => $choria::srvdomain,
  }

  if $choria::mcollective_config_dir != "" {
    $_config_dir = dirname($choria::server_config_file)

    if $_config_dir != $choria::mcollective_config_dir {
      file{"${_config_dir}/plugin.d":
        ensure => link,
        target => "${choria::mcollective_config_dir}/plugin.d"
      }

      file{"${_config_dir}/policies":
        ensure => link,
        target => "${choria::mcollective_config_dir}/policies"
      }
    }
  }

  if "plugin.scout.goss.file" in $choria::server_config {
    file{$choria::server_config["plugin.scout.goss.file"]:
      content => $choria::scout_gossfile.to_yaml,
      owner   => $choria::config_user,
      group   => $choria::config_group,
      mode    => "0755",
    }
  }

  if "plugin.scout.overrides" in $choria::server_config {
    file{$choria::server_config["plugin.scout.overrides"]:
      content => $choria::scout_overrides.to_json,
      owner   => $choria::config_user,
      group   => $choria::config_group,
      mode    => "0755",
    }
  }

  if "plugin.choria.machine.store" in $choria::server_config {
    if $choria::purge_machines {
      $purge_options = {
        source  => "puppet:///modules/choria/empty",
        ignore  => ".keep",
        purge   => true,
        recurse => true,
        force   => true
      }
    } else {
      $purge_options = {}
    }

    file{
      default:
        * =>  $purge_options;

      $choria::server_config["plugin.choria.machine.store"]:
        ensure => directory,
        owner  => $choria::config_user,
        group  => $choria::config_group,
        mode   => "0755",
    }
  }

  if "plugin.choria.agent_provider.mcorpc.agent_shim" in $choria::server_config and "plugin.choria.agent_provider.mcorpc.config" in $choria::server_config {
    if $choria::server_config["plugin.choria.agent_provider.mcorpc.agent_shim"] =~ /\.bat$/ {
      $agent_shim = $choria::server_config["plugin.choria.agent_provider.mcorpc.agent_shim"].regsubst(/\.bat$/, '.rb')
      $agent_shim_wrapper = $choria::server_config["plugin.choria.agent_provider.mcorpc.agent_shim"]
    } else {
      $agent_shim = $choria::server_config["plugin.choria.agent_provider.mcorpc.agent_shim"]
      $agent_shim_wrapper = undef
    }

    file{$agent_shim:
      owner   => $choria::config_user,
      group   => $choria::config_group,
      mode    => "0755",
      content => epp("choria/choria_mcollective_agent_compat.rb.epp")
    }

    if $agent_shim_wrapper {
      file{$agent_shim_wrapper:
        owner   => $choria::config_user,
        group   => $choria::config_group,
        mode    => "0755",
        content => epp("choria/choria_mcollective_agent_compat.bat.epp")
      }
    }
  }

  if $choria::manage_server_config {
    file{$choria::server_config_file:
      owner   => $choria::config_user,
      group   => $choria::config_group,
      mode    => "0640",
      content => choria::hash2config($config),
      notify  => Class["choria::service"],
      require => Class["choria::install"]
    }
  }

  if $choria::server_provisioning_token {
    file{$choria::server_provisioning_token_file:
      owner   => $choria::config_user,
      group   => $choria::config_group,
      mode    => "0640",
      content => $choria::server_provisioning_token,
      notify  => Class["choria::service"],
      require => Class["choria::install"],
    }
  }
}

