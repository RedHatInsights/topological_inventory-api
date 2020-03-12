module Api
  module V3x0
    class SubscriptionsController < Api::V2x0::SubscriptionsController
      include Mixins::IndexMixin
    end
  end
end
