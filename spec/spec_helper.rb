def spec_dir
  File.dirname(__FILE__)
end

def root_dir
  File.expand_path(File.join(spec_dir, '..'))
end

def resources_dir
  File.join(spec_dir, 'resources')
end

def resource(file_name)
  File.join(resources_dir, file_name)
end

require "#{root_dir}/lib/rasper"

jar_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'java', 'jars'))
unless File.exists?(jar_dir)
  raise "Before running tests, you should download JAR files to #{jar_dir}."
end
Rasper::JARLoader.jar_dir = jar_dir