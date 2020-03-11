module Api
  module V3x0
    class ServiceOfferingsController < Api::V1::ServiceOfferingsController
      include Mixins::IndexMixin
    end
  end
end
