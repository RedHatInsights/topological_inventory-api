module Api
  module V3x0
    class ServiceInventoriesController < Api::V1::ServiceInventoriesController
      include Mixins::IndexMixin
    end
  end
end
