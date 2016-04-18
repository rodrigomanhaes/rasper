require 'java'

Rasper::JARLoader.load

java_import Java::net::sf::jasperreports::engine::data::JRXmlDataSource
java_import Java::net::sf::jasperreports::engine::util::FileResolver
java_import Java::net::sf::jasperreports::engine::JasperRunManager
java_import Java::java::io::ByteArrayInputStream
java_import Java::java::io::BufferedInputStream
java_import Java::java::util::Locale

require 'active_support/core_ext'

module Rasper
  class Report
    extend Locale

    class << self
      def generate(jasper_name, data, params = {})
        run_with_locale do
          namespace, jasper_name = extract_namespace(jasper_name)
          set_file_resolver(params, namespace)
          file_name = File.join(Config.jasper_dir || '.', namespace,
            jasper_name + '.jasper')
          jasper_content = File.read(file_name)
          data = { jasper_name => data }.to_xml
          xpath_criteria = "/hash/#{jasper_name}/#{jasper_name.singularize}"
          source = JRXmlDataSource.new(
              ByteArrayInputStream.new(data.to_java_bytes), xpath_criteria)
          input = BufferedInputStream.new(
              ByteArrayInputStream.new(jasper_content.to_java_bytes))
          String.from_java_bytes(
            JasperRunManager.runReportToPdf(input, params, source))
        end
      end

      private

      def set_file_resolver(params, namespace = '')
        resolver = FileResolver.new
        image_directory = Config.image_dir
        resolver.singleton_class.instance_eval do
          define_method :resolve_file do |filename|
            java::io::File.new(File.join(image_directory, namespace, filename))
          end
        end
        params['REPORT_FILE_RESOLVER'] = resolver
      end

      def extract_namespace(name)
        parts = name.split('/')
        jasper_name = parts.pop
        namespace = parts.join('/')
        [namespace, jasper_name]
      end
    end
  end
end
