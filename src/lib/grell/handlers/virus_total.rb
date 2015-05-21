module Grell
  module Handlers
    class VirusTotal < Grell::Base
      define_options do
        # See Grell::BaseConfigHandler

        # See Virtus.model
        # An array of API keys to use when querying VirusTotal
        attribute :apikeys, Array[String]

        # Validations... See ActiveModel::Validations
        validate do
          errors.add(:apikeys, "At least one apikey must be defined!") if self.apikeys.empty?
        end
      end

      api do
        # See Grape::API

        helpers do
          # Returns a random API key from the grell configuration.
          def apikey
            ret = grell_config.apikeys.sample(1).first
            ret
          end
        end

        desc "Looks up a virustotal report for a file hash"
        params do
          use :bypass_cache # Adds common 'bypass_cache' parameter
          requires :resource, type: String, desc: "The resource to look up. Can be an md5, sha1, sha256"
        end
        post '/file/report' do
          client = http_client()
          resource = params[:resource].downcase
          body = {
            apikey: apikey,
            resource: resource
          }

          # Specify the caching key
          client.headers[:cache_key] = "#{self.class.name}-file-report-#{resource}"

          response = client.post('https://www.virustotal.com/vtapi/v2/file/report', body)

          if response.status  == 200
            status 200
            return MultiJson.load(response.body)
          elsif response.status == 204
            error!("Retry later.", 204)
          else
            error!("Server Error", 500)
          end
        end

        desc "Look up a virustotal report for a URL"
        params do
          use :bypass_cache # Adds common 'bypass_cache' parameter
          requires :resource, type: String, desc: "The URL to look up."
        end
        post '/url/report' do
          client = http_client()
          resource = params[:resource]
          body = {
            apikey: apikey,
            resource: resource
          }

          # Specify the caching key
          client.headers[:cache_key] = "#{self.class.name}-url-report-#{resource}"

          response = client.post('https://www.virustotal.com/vtapi/v2/url/report', body)

          if response.status  == 200
            status 200
            return MultiJson.load(response.body)
          elsif response.status == 204
            error!("Retry later.", 204)
          else
            error!("Server Error", 500)
          end
        end

        desc "Look up a virustotal report for an IP address"
        params do
          use :bypass_cache # Adds common 'bypass_cache' parameter
          requires :ip, type: String, desc: "The IP to look up."
        end
        get '/ip-address/report' do
          client = http_client()
          ip = params[:ip]
          get_params = {
            apikey: apikey,
            ip: ip
          }

          # Specify the caching key
          client.headers[:cache_key] = "#{self.class.name}-ip-address-report-#{ip}"

          response = client.get('https://www.virustotal.com/vtapi/v2/ip-address/report', get_params)

          if response.status  == 200
            status 200
            return MultiJson.load(response.body)
          elsif response.status == 204
            error!("Retry later.", 204)
          else
            error!("Server Error", 500)
          end
        end

        desc "Look up a virustotal report for an domain name"
        params do
          use :bypass_cache # Adds common 'bypass_cache' parameter
          requires :domain, type: String, desc: "The domain to look up."
        end
        get '/domain/report' do
          client = http_client()
          domain = params[:domain].downcase
          get_params = {
            apikey: apikey,
            domain: domain
          }

          # Specify the caching key
          client.headers[:cache_key] = "#{self.class.name}-domain-report-#{domain}"

          response = client.get('https://www.virustotal.com/vtapi/v2/domain/report', get_params)

          if response.status  == 200
            status 200
            return MultiJson.load(response.body)
          elsif response.status == 204
            error!("Retry later.", 204)
          else
            error!("Server Error", 500)
          end
        end

      end
    end
  end
end
