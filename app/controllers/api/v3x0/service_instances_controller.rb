module Api
  module V3x0
    class ServiceInstancesController < Api::V2x0::ServiceInstancesController
      include Mixins::IndexMixin
    end
  end
end
