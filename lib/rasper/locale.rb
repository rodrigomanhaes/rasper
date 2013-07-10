require 'java'

java_import Java::java::util::Locale

module Rasper
  module Locale

    def run_with_locale
      set_locale
      begin
        yield
      ensure
        restore_locale
      end
    end

    private

    def set_locale
      return unless Config.locale
      @default_locale = ::Locale.get_default
      ::Locale.set_default(::Locale.new(*Config.locale.split('_')))
    end

    def restore_locale
      ::Locale.set_default(@default_locale) if @default_locale
    end
  end
end