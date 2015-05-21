class API < Grape::API
  version 'v1', using: :header, vendor: 'grell'
  format :json

  grell_config = Grell::Config.new(YAML.load_file(ENV['GRELL_CONFIG']))
  global_setting('grell.cache_ttl', grell_config.cache_ttl)

  grell_config.each_api do |api, path|
    mount api => path
  end

  add_swagger_documentation :base_path => '/',
                            :format => 'json'
end
