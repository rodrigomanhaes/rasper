module Rasper
  class JARLoader
    class << self
      attr_accessor :jar_dir

      def load
        Dir.entries(jar_dir).each do |lib|
          require File.join(jar_dir, lib) if lib =~ /\.jar$/
        end
      end
    end
  end
end