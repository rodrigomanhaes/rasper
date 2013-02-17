module Rasper
  class JARLoader
    class << self
      attr_accessor :jar_dir

      def load
        root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
        jar_dir ||= File.join(root_dir, 'java', 'jars')
        Dir.entries(jar_dir).each do |lib|
          require File.join(jar_dir, lib) if lib =~ /\.jar$/
        end
      end
    end
  end
end