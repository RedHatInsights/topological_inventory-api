module Api
  module V3x0
    class ContainersController < Api::V1::ContainersController
      include Mixins::IndexMixin
    end
  end
end
