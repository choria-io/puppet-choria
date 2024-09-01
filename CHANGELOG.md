|Date      |Issue|Description                                                                                              |
|----------|-----|---------------------------------------------------------------------------------------------------------|
|2024/09/01|     |Release 0.31.0                                                                                           |
|2024/08/23|356  |Support v2 protocol security when creating KV and Governors using Puppet types                           |
|2024/04/02|355  |Switched to the static key URL to optimize key downloads                                                 |
|2024/03/22|352  |Allow `choria::task::run` to catch errors                                                                |
|2024/03/12|350  |Support v2 provisioning connections                                                                      |
|2024/03/11|248  |Fix protocol v2 issuers and security                                                                     |
|2024/02/20|345  |Fix adapters data type                                                                                   |
|2024/02/04|     |Release 0.30.3                                                                                           |
|2024/02/04|     |Update dependencies                                                                                      |
|2024/02/03|     |Release 0.30.2                                                                                           |
|2024/01/08|339  |Use modern APT keyrings on Debian family                                                                 |
|2023/12/27|336  |Ensure tasks from non-production environments actually work                                              |
|2023/10/06|     |Release 0.30.1                                                                                           |
|2023/09/18|331  |Adds the architecture parameter to remove warnings about unsupported architectures                       |
|2023/09/18|     |Release 0.30.0                                                                                           |
|2023/08/30|329  |Allow playbooks and tasks from non production environments                                               |
|2023/02/23|     |New defined type `choria::group` to manage groups in access policies                                     |
|2023/03/22|     |Release 0.29.0                                                                                           |
|2022/09/21|     |Release 0.28.3                                                                                           |
|2022/09/14|320  |Allow `plugin.choria.network.gateway_name` to be set via `choria::broker::cluster_name`                  |
|2022/09/04|317  |Allow latest puppetlabs/apt module to be used                                                            |
|2022/08/03|     |Release 0.28.2                                                                                           |
|2022/06/23|     |Release 0.28.1                                                                                           |
|2022/06/23|314  |Support code name in debian versions                                                                     |
|2022/06/23|     |Release 0.28.0                                                                                           |
|2022/06/09|311  |Support EL9                                                                                              |
|2022/06/03|     |Support Linux Mint                                                                                       |
|2022/05/16|     |Release 0.27.3                                                                                           |
|2022/05/16|307  |Allow hostnames in stats listen address                                                                  |
|2022/05/11|     |Release 0.27.2                                                                                           |
|2022/05/11|303  |Fix syntax errors affecting playbooks                                                                    |
|2022/03/23|301  |Remove Xenial and Stretch from support operatating systems                                               |
|2022/02/24|298  |Support systems without IPv6                                                                             |
|2022/02/23|     |Release 0.27.1                                                                                           |
|2022/02/23|     |Update dependencies to fix choria/mcollective bug                                                        |
|2022/02/23|     |Release 0.27.0                                                                                           |
|2022/02/10|     |Allow access to Choria::TaskResults#bolt_task_result                                                     |
|2022/01/25|292  |Add package_source parameter                                                                             |
|2022/01/12|290  |Provide stats over the loopback address, allow the stats to be disabled entirely                         |
|2021/12/17|287  |Add choria::kv_buckets and choria::governors                                                             |
|2021/10/16|281  |Arch Linux: Switch from Ruby 2.7 to 3                                                                    |
|2021/09/22|278  |Add the choria_kv_bucket resource                                                                        |
|2021/09/21|     |Release 0.26.2                                                                                           |
|2021/09/21|     |Fix Debian releases                                                                                      |
|2021/09/21|     |Release 0.26.1                                                                                           |
|2021/09/21|     |Fix nightly repository ensure property                                                                   |
|2021/09/21|     |Release 0.26.0                                                                                           |
|2021/09/17|271  |Support new package repositories                                                                         |
|2021/09/20|273  |Add a type and provider to manage governors                                                              |
|2021/09/03|269  |Arch Linux: adjust package name from choria to choria-io                                                 |
|2021/09/03|267  |Arch Linux: Use /usr/bin/ruby-2.7 instead of default Ruby 3                                              |
|2021/08/24|     |Release 0.25.0                                                                                           |
|2021/08/13|262  |Support allowing provisioning against a core Choria Broker                                               |
|2021/08/04|260  |Rename `jetstream` adapter to `choria_streams`                                                           |
|2021/07/14|258  |Prepare autonomous agents for data storage                                                               |
|2021/05/20|235  |Support puppetlabs/apt 8.x                                                                               |
|2021/07/10|254  |Support configuring core Stream replica configuration                                                    |
|2021/06/19|     |Release 0.24.0                                                                                           |
|2021/04/28|     |Use EL8 repo for Fedora                                                                                  |
|2021/04/28|247  |Support websocket ports                                                                                  |
|2021/03/29|     |Release 0.23.0                                                                                           |
|2021/03/23|238  |Support configuring leafnode connections                                                                 |
|2021/03/22|235  |Support latest puppetlabs/stdlib                                                                         |
|2021/03/22|233  |Enable access to the NATS system account                                                                 |
|2021/03/10|231  |Support configuring Streaming                                                                            |
|2021/03/03|230  |Add `server_service_enable` parameter                                                                    |
|2021/01/13|     |Release 0.22.2                                                                                           |
|2021/01/13|     |Ensure `choria` version `0.20.2` is installed on RedHat and Debian                                       |
|2021/01/13|     |Release 0.22.1                                                                                           |
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
