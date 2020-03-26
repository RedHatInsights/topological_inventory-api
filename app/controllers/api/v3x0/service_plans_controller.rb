module Api
  module V3x0
    class ServicePlansController < Api::V2x0::ServicePlansController
      include Mixins::IndexMixin
    end
  end
end
