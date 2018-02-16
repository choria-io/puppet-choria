require "puppetlabs_spec_helper/rake_tasks"

begin
  if Gem::Specification::find_by_name("puppet-lint")
    require "puppet-lint/tasks/puppet-lint"
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]
    task :default => [:spec, :lint]
  end
rescue Gem::LoadError
  task :default => :spec
end
