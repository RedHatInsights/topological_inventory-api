module Api
  module V3x0
    class SourcesController < Api::V1::SourcesController
      include Mixins::IndexMixin
    end
  end
end
