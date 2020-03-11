module Api
  module V3x0
    class TagsController < Api::V1::TagsController
      include Mixins::IndexMixin
    end
  end
end
