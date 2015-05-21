module Grell
  class Config
    def initialize(data)
      @cache_ttl = data['cache_ttl'] || 3600
      @routes = {}
      init_routes(data["routes"])
    end

    def cache_ttl
      @cache_ttl
    end

    def each_api
      @routes.each_pair do |path, api|
        yield(api, path)
      end
    end

    private
    def init_routes(routes)
      routes.each_pair do |path, opts|
        klassname = opts.delete('class')
        if klassname.nil?
          raise Grell::Exceptions::ConfigError.new("Missing 'class' for '#{path}'")
        end
        begin
          klass = full_const_get(klassname)
        rescue NameError => e
          raise Grell::Exceptions::ConfigError.new("Invalid 'class' (#{klassname}) for '#{path}': #{e.message}")
        end

        options_handler = klass.options_handler()

        begin
          config = options_handler.new(opts)
        rescue => e
          raise Grell::Exceptions::ConfigError.new("Invalid config for '#{path}': #{e.message}")
        end

        if !config.valid?
          raise Grell::Exceptions::ConfigError.new("Invalid config for '#{path}': #{config.errors.full_messages}")
        end

        @routes[path] = klass.generate(config)
      end
    end

    def full_const_get(name)
      list = name.split("::")
      list.shift if list.first.empty?
      obj = Object
      list.each do |x|
        obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
      end
      obj
    end
  end
end
