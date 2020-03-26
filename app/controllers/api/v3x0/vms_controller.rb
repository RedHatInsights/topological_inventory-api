module Api
  module V3x0
    class VmsController < Api::V2x0::VmsController
      include Mixins::IndexMixin
    end
  end
end
