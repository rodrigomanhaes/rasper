require 'java'

Rasper::JARLoader.load

java_import Java::net::sf::jasperreports::engine::data::JRXmlDataSource
java_import Java::net::sf::jasperreports::engine::JasperRunManager
java_import Java::java::io::ByteArrayInputStream
java_import Java::java::io::BufferedInputStream

require 'active_support/core_ext'

module Rasper
  class Report
    class << self
      attr_accessor :jasper_dir

      def generate(jasper_name, data)
        file_name = File.join(jasper_dir || '.', jasper_name + '.jasper')
        jasper_content = File.read(file_name)
        data = { jasper_name => data }.to_xml
        xpath_criteria = "/hash/#{jasper_name}/#{jasper_name.singularize}"
        source = JRXmlDataSource.new(
            ByteArrayInputStream.new(data.to_java_bytes), xpath_criteria)
        input = BufferedInputStream.new(
            ByteArrayInputStream.new(jasper_content.to_java_bytes))
        String.from_java_bytes(
          JasperRunManager.runReportToPdf(input, nil, source))
      end

      private
    end
  end
end