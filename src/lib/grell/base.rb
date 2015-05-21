module Grell
  class Base
    def self.options_handler
      @options_handler || BaseOptionsHandler
    end

    def self.generate(config)
      Class.new(::Grape::API).tap do |api|
        api.helpers Grell::Grape::SharedParams
        api.helpers Grell::Grape::ConfigHelpers
        api.helpers Grell::Grape::HTTPHelpers
        api.api_class_setting(:grell_config, config)
        api.instance_eval(&@api_proc) unless @api_proc.nil?
      end
    end

    def self.define_options(&block)
      name = "#{self}.define_options"
      @options_handler = Class.new(BaseOptionsHandler).tap do |klass|
        @@name = name
        def klass.name
          @@name
        end
        klass.instance_eval(&block)
      end
    end

    def self.api(&block)
      @api_proc = block
    end

  end
end
