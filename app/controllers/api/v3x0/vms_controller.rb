module Api
  module V3x0
    class VmsController < Api::V1::VmsController
      include Mixins::IndexMixin
    end
  end
end
