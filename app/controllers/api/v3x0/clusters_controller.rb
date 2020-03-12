module Api
  module V3x0
    class ClustersController < Api::V2x0::ClustersController
      include Mixins::IndexMixin
    end
  end
end
