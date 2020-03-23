module Api
  module V3x0
    class ContainersController < Api::V2x0::ContainersController
      include Mixins::IndexMixin
    end
  end
end
