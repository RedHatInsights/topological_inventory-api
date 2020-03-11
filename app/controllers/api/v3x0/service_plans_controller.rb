module Api
  module V3x0
    class ServicePlansController < Api::V1::ServicePlansController
      include Mixins::IndexMixin
    end
  end
end
