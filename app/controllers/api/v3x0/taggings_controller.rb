module Api
  module V3x0
    class TaggingsController < Api::V2x0::TaggingsController
      include Mixins::IndexMixin
    end
  end
end
