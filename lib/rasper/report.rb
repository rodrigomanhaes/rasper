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
    class << self
      def generate(jasper_name, data, params = {})
        set_file_resolver(params)
        set_locale
        begin
          file_name = File.join(Config.jasper_dir || '.', jasper_name + '.jasper')
          jasper_content = File.read(file_name)
          data = { jasper_name => data }.to_xml
          xpath_criteria = "/hash/#{jasper_name}/#{jasper_name.singularize}"
          source = JRXmlDataSource.new(
              ByteArrayInputStream.new(data.to_java_bytes), xpath_criteria)
          input = BufferedInputStream.new(
              ByteArrayInputStream.new(jasper_content.to_java_bytes))
          String.from_java_bytes(
            JasperRunManager.runReportToPdf(input, params, source))
        ensure
          restore_locale
        end
      end

      private

      def set_file_resolver(params)
        resolver = FileResolver.new
        image_directory = Config.image_dir
        resolver.singleton_class.instance_eval do
          define_method :resolve_file do |filename|
            java::io::File.new("#{image_directory}/#{filename}")
          end
        end
        params['REPORT_FILE_RESOLVER'] = resolver
      end

      def set_locale
        return unless Config.locale
        @default_locale = Locale.get_default
        Locale.set_default(Locale.new(*Config.locale.split('_')))
      end

      def restore_locale
        Locale.set_default(@default_locale) if @default_locale
      end
    end
  end
end