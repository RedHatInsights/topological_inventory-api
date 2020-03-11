module Api
  module V3x0
    class ServiceInstanceNodesController < Api::V1::ServiceInstanceNodesController
      include Mixins::IndexMixin
    end
  end
end
