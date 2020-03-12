module Api
  module V3x0
    class TagsController < Api::V2x0::TagsController
      include Mixins::IndexMixin
    end
  end
end
