|Date      |Issue|Description                                                                                              |
|----------|-----|---------------------------------------------------------------------------------------------------------|
|2021/01/13|     |Release 0.22.0                                                                                           |
|2021/01/13|     |Ensure `choria` version `0.20.1` is installed on RedHat and Debian                                       |
|2021/01/13|     |Release 0.22.0                                                                                           |
|2021/01/18|     |Support `run_as` for playbooks                                                                           |
|2021/01/15|207  |Ensure the `mcollective` class is included when just including `choria`                                  |
|2021/01/13|     |Release 0.21.0                                                                                           |
|2020/10/26|     |Correctly describe the NATS Streaming Server adapter data type                                           |
|2021/01/10|217  |Remove support for legacy compound filters                                                               |
|2020/12/29|207  |Simplify choria module dependencies by moving all to this module                                         |
|2020/12/29|207  |Migrate configuration to `/etc/choria`                                                                   |
|2020/12/28|210  |Move mcollective_agent_bolt_tasks::ping task to choria::ping                                             |
|2020/12/28|208  |Correctly support disabling the Choria Server                                                            |
|2020/12/16|200  |Impove Puppet 7 support                                                                                  |
|2020/12/21|195  |Support yum repositories on CentOS 8                                                                     |
|2020/12/21|203  |Improve testing harness using rspec-puppet-facts                                                         |
|2020/12/21|203  |Improve testing harness using rspec-puppet-facts                                                         |
|2020/12/21|204  |Remove unsupported operating systems                                                                     |
|2020/12/15|198  |Add support for setting additional properties in scout checks                                            |
|2020/12/13|196  |Remove references to `mcollectived`                                                                      |
|2020/12/04|192  |Add `choria::scout_metric`                                                                               |
|2020/11/25|     |Release 0.20.0                                                                                           |
|2020/10/22|188  |Add FreeBSD support for choria                                                                           |
|2020/10/21|188  |Always deploy choria server                                                                              |
|2020/10/02|187  |Support Ubuntu focal and KDE neon 20.04                                                                  |
|2020/09/28|     |Release 0.19.0                                                                                           |
|2020/08/03|181  |Support Scout check annotations                                                                          |
|2020/08/03|179  |On resuming a Scout check move to `unknown` not `force`                                                  |
|2020/07/22|175  |Support multiple Gossfiles                                                                               |
|2020/07/17|     |Release 0.18.0                                                                                           |
|2020/07/16|172  |Support creating a gossfile from hiera                                                                   |
|2020/07/16|170  |Add choria::scout_checks helper                                                                          |
|2020/07/07|     |Release 0.17.0                                                                                           |
|2020/06/28|164  |Improve package repository management                                                                    |
|2020/06/20|158  |Support creating Choria Scout checks and overrides                                                       |
|2020/07/01|     |Release 0.16.0                                                                                           |
|2020/06/26|164  |Improve package repository management logic                                                              |
|2020/06/24|158  |Support adding Choria Scout health checks                                                                |
|2020/04/19|     |Release 0.16.0                                                                                           |
|2020/04/01|155  |Add `choria::playbook_exist` function                                                                    |
|2020/02/11|151  |Support Amazon Linux                                                                                     |
|2020/01/27|135  |Allow GPG repo checking behaviour to be configured                                                       |
|2020/01/25|115  |Allow the `ssldir` setting to be configured by the module                                                |
|2020/01/04|143  |New configuration options for auto provisioning support                                                  |
|2020/01/04|145  |Improve windows support                                                                                  |
|2019/12/06|142  |Add `choria::sleep` playbook function                                                                    |
|2019/11/25|     |Release 0.15.0                                                                                           |
|2019/11/21|113  |Improve resource ordering on debian systems                                                              |
|2019/09/19|130  |Allow splitting services log into server and broker logs                                                 |
|2019/09/20|     |Release 0.14.0                                                                                           |
|2019/09/17|127  |Create a symlink of mcollective policies into choria                                                     |
|2019/08/20|125  |Allow client_hosts to be set in broker config                                                            |
|2019/08/18|123  |Create a symlink mcollective plugin.d into choria                                                        |
|2019/08/16|121  |Allow top-level choria::server_config options to be arrays                                               |
|2019/08/15|119  |Allow broker TLS timeout to be configured                                                                |
|2019/07/23|108  |Improve packaging on CentOS 7, drops support for 5                                                       |
|2019/05/27|     |Release 0.13.1                                                                                           |
|2019/03/13|113  |Ensure APT repositories are managed before the packages                                                  |
|2019/03/14|111  |Disable repo_gpgcheck for yum repos to enable mirrors to be made                                         |
|2019/03/04|     |Release 0.13.0                                                                                           |
|2019/01/30|106  |Allow the Package Cloud repo to be mirrored and a local url used when configuring the repos              |
|2018/12/01|     |Release 0.12.0                                                                                           |
|2018/11/30|102  |Write the Choria Server status file by default                                                           |
|2018/11/27|99   |On AIO Puppet 6 enable Choria Server by default                                                          |
|2018/11/12|88   |Use the correct hash2config function                                                                     |
|2018/10/13|     |Release 0.11.1                                                                                           |
|2018/10/03|94   |Allow latest apt and stdlib modules to be used                                                           |
|2018/09/20|     |Release 0.11.0                                                                                           |
|2018/07/31|84   |Improve itterators in the plan DSL to return collected results instead of items                          |
|2018/07/31|81   |Support for compound filters outside of mcollectived                                                     |
|2018/07/20|     |Release 0.10.0                                                                                           |
|2018/07/20|77   |Ensure removal of mcollective plugins by way of the directory purge feature restarts choria server       |
|2018/07/11|75   |Support ubuntu 18.04, and remove old operating systems                                                   |
|2018/07/05|71   |Rename `log_file` to `logfile` to improve consistency between our modules                                |
|2018/07/06|73   |Improve support for servers with facter 2.5 like those installed from gems                               |
|2018/05/21|     |Release 0.9.0                                                                                            |
|2018/05/18|68   |Fix inverted logic in `on_error` and `on_success` playbook helpers                                       |
|2018/05/05|61   |Support invoking Puppet Tasks from Playbooks                                                             |
|2018/04/59|59   |Create a minimal config tailored to the needs of the ruby compat shim                                    |
|2018/04/25|57   |Ensure Choria Server auditing is enabled                                                                 |
|2018/04/24|     |Release 0.8.0                                                                                            |
|2018/04/19|53   |Configure the `choria server` component                                                                  |
|2018/04/02|49   |Improve handling of `on_error` in Playbooks                                                              |
|2018/03/23|45   |Ensure the `server` service is off by default                                                            |
|2018/03/22|     |Release 0.7.1                                                                                            |
|2018/03/22|43   |Ensure apt-get update gets run after adding deb repositories                                             |
|2018/03/22|41   |Improve debian/ubuntu support by setting the identity specifically                                       |
|2018/03/21|     |Release 0.7.0                                                                                            |
|2018/03/06|36   |Add mandatory `name` option to the YUM repositories                                                      |
|2018/03/04|32   |Add missing install dependency to improve puppet run ordering                                            |
|2018/03/02|6    |Support managing the Choria Ubuntu and Debian repositories                                               |
|2018/03/02|21   |Support managing the Choria Data Adapters                                                                |
|2018/03/02|5    |Support managing the Choria Federation Broker                                                            |
|2018/03/01|4    |Support managing the Choria Network Broker                                                               |
|2018/02/25|     |Release 0.1.0                                                                                            |
|2018/02/24|14   |Add Choria::ShellSafe                                                                                    |
|2018/02/23|12   |Add choria::in_groups_of                                                                                 |
|2018/02/23|1    |Support functions, types and helpers to support playbooks in the Puppet DSL                              |
|2018/02/16|3    |Manage the YUM repository on EL machines                                                                 |
