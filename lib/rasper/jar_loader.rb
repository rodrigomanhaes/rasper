module Rasper
  class JARLoader
    def self.load
      Dir.entries(Config.jar_dir).each do |lib|
        require File.join(Config.jar_dir, lib) if lib =~ /\.jar$/
      end
    end
  end
end