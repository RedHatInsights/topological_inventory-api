module Api
  module V3x0
    class ServiceInstanceNodesController < Api::V2x0::ServiceInstanceNodesController
      include Mixins::IndexMixin
    end
  end
end
