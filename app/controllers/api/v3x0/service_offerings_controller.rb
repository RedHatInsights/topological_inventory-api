module Api
  module V3x0
    class ServiceOfferingsController < Api::V2x0::ServiceOfferingsController
      include Mixins::IndexMixin
    end
  end
end
