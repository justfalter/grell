module Grell
  module Grape
    module SharedParams
      extend ::Grape::API::Helpers

      params :bypass_cache do
        optional :bypass_cache, type: ::Grape::API::Boolean, default: false,
          desc: "Set to true to bypass cache"
      end
    end
  end
end

