module Api
  module V1
    class SubscriptionsController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
    end
  end
end
