module Api
  module V3x0
    class AvailabilitiesController < Api::V1::AvailabilitiesController
      include Mixins::IndexMixin
    end
  end
end
