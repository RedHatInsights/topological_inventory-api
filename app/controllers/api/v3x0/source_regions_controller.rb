module Api
  module V3x0
    class SourceRegionsController < Api::V1::SourceRegionsController
      include Mixins::IndexMixin
    end
  end
end
