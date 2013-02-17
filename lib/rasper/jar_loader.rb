module Rasper
  class JARLoader
    def self.load
      root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      jars_dir = File.join(root_dir, 'java', 'jars')
      Dir.entries(jars_dir).each do |lib|
        require File.join(jars_dir, lib) if lib =~ /\.jar$/
      end
    end
  end
end