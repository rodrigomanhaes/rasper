require 'java'

root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
jars_dir = File.join(root_dir, 'java', 'jars')
Dir.entries(jars_dir).each do |lib|
  require File.join(jars_dir, lib) if lib =~ /\.jar$/
end

java_import Java::net::sf::jasperreports::engine::JasperCompileManager

module Rasper
  class Compiler
    def self.compile(jrxml_file, output_dir = nil)
      output_dir ||= File.dirname(jrxml_file)
      output_file = File.join(output_dir, File.basename(jrxml_file, '.jrxml') + '.jasper')
      JasperCompileManager.compile_report_to_file(jrxml_file, output_file)
    end
  end
end