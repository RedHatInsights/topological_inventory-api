module Api
  module V3x0
    class FlavorsController < Api::V1::FlavorsController
      include Mixins::IndexMixin
    end
  end
end
