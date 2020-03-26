module Api
  module V3x0
    class SourceRegionsController < Api::V2x0::SourceRegionsController
      include Mixins::IndexMixin
    end
  end
end
