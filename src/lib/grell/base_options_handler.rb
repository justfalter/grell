require 'virtus'

module Grell
  class BaseOptionsHandler
    include Virtus.model(strict: true)
    include ActiveModel::Validations
  end
end
