require 'java'

Rasper::JARLoader.load

java_import Java::net::sf::jasperreports::engine::JasperCompileManager

module Rasper
  class Compiler
    extend Locale

    def self.compile(jrxml_file, output_dir = nil)
      run_with_locale do
        output_dir ||= File.dirname(jrxml_file)
        output_file = File.join(output_dir, File.basename(jrxml_file, '.jrxml') + '.jasper')
        JasperCompileManager.compile_report_to_file(jrxml_file, output_file)
      end
    end
  end
end