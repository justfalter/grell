require 'grell/faraday_cache'

module Grell
  module Grape
    module HTTPHelpers
      def http_client()
        opts = {}
        if params[:bypass_cache]
          opts[:headers] ||= {}
          opts[:headers][:cache_bypass] = "1"
        end

        cache_ttl = global_setting('grell.cache_ttl')

        Faraday::Connection.new(opts) do |builder|
          builder.request :grell_faraday_cache
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
        end
      end
    end
  end
end

