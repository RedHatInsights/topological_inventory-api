module Api
  module V3x0
    class ServiceInstancesController < Api::V1::ServiceInstancesController
      include Mixins::IndexMixin
    end
  end
end
