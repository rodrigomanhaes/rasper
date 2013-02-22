module Rasper
  class Config
    class << self
      attr_reader :jar_dir, :jasper_dir, :image_dir
    end

    def self.configure
      conf = Configuration.new
      yield conf
      @jar_dir = conf.jar_dir
      @jasper_dir = conf.jasper_dir
      @image_dir = conf.image_dir
    end

    private

    class Configuration
      attr_accessor :jar_dir, :jasper_dir, :image_dir
    end
  end
end