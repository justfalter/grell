require 'grell/faraday_cache'

module Grell
  module Grape
    module SharedParams
      extend ::Grape::API::Helpers

      params :bypass_cache do
        optional :bypass_cache, type: ::Grape::API::Boolean, default: false,
          desc: "Set to true to bypass cache"
      end
    end

    module ConfigHelpers
      def grell_config 
        return api_class_setting(:grell_config)
      end
    end

    module HTTPHelpers
      def http_client()
        opts = {}
        if params[:bypass_cache]
          opts[:headers] ||= {}
          opts[:headers][:cache_bypass] = "1"
        end

        Faraday::Connection.new(opts) do |builder|
          builder.request :grell_faraday_cache
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
        end
      end
    end
  end
end
