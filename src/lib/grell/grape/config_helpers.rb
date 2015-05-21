module Grell
  module Grape
    module ConfigHelpers
      def grell_config 
        return api_class_setting(:grell_config)
      end
    end
  end
end

