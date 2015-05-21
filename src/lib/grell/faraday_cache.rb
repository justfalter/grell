require 'faraday'
require 'forwardable'

module Grell
  # Public: Caches any 200 response. Originally found in faraday_middleware. 
  class FaradayCache < Faraday::Middleware
    CACHEABLE_STATUS_CODES = [200]

    extend Forwardable
    def_delegators :'Faraday::Utils', :parse_query, :build_query

    # Public: initialize the middleware.
    def initialize(app, options = {})
      super(app)
      @cache = Rails.cache
      @ttl = (options[:ttl] || 3600.seconds).seconds
    end

    def call(env)
      cache_key = env.request_headers.delete(:cache_key)
      cache_bypass = env.request_headers.delete(:cache_bypass)

      if cache_key.nil?
        # Skip caching all-together
        return @app.call(env)
      end

      cache_status = :MISS
      if cache_bypass == "1"
        cache_status = :BYPASS
      else
        if response = @cache.fetch(cache_key) and response
          response = finalize_response(response, env)
          response.env.response_headers["X-Cache-Status"] = :HIT
          return response
        end
      end

      response = @app.call(env)
      response.on_complete do |response_env|
        if CACHEABLE_STATUS_CODES.include?(response.status)
          response_env.response_headers["X-Cache-Status"] = cache_status
          save_to_cache(cache_key, response)
        end
      end
    end

    def save_to_cache(cache_key, response)
      @cache.write(cache_key, response, expires_in: @ttl)
    end

    def finalize_response(response, env)
      response = response.dup if response.frozen?
      env[:response] = response
      unless env[:response_headers]
        env.update response.env
        # FIXME: omg hax
        response.instance_variable_set('@env', env)
      end
      response
    end
  end

  Faraday::Request.register_middleware :grell_faraday_cache => lambda { ::Grell::FaradayCache }
end
