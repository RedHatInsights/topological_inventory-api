module Api
  module V3x0
    class ServiceInventoriesController < Api::V2x0::ServiceInventoriesController
      include Mixins::IndexMixin
    end
  end
end
