module Rasper
  class Config
    class << self
      attr_reader :jar_dir, :jasper_dir, :image_dir, :locale
    end

    def self.configure
      conf = Configuration.new
      yield conf
      @jar_dir = conf.jar_dir if conf.jar_dir
      @jasper_dir = conf.jasper_dir if conf.jasper_dir
      @image_dir = conf.image_dir if conf.image_dir
      @locale = conf.locale if conf.locale
    end

    private

    class Configuration
      attr_accessor :jar_dir, :jasper_dir, :image_dir, :locale
    end
  end
end