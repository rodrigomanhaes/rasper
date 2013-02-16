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