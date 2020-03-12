module Api
  module V3x0
    class FlavorsController < Api::V2x0::FlavorsController
      include Mixins::IndexMixin
    end
  end
end
