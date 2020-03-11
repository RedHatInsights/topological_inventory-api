module Api
  module V3x0
    class SubscriptionsController < Api::V1::SubscriptionsController
      include Mixins::IndexMixin
    end
  end
end
