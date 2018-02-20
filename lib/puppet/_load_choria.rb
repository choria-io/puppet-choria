["/opt/puppetlabs/mcollective/plugins", "C:/ProgramData/PuppetLabs/mcollective/plugins"].each do |libdir|
  next if $LOAD_PATH.include?(libdir)
  next unless File.directory?(libdir)

  $LOAD_PATH << libdir
end

require "mcollective/util/bolt_support"
