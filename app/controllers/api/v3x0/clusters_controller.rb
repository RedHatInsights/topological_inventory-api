module Api
  module V3x0
    class ClustersController < Api::V1::ClustersController
      include Mixins::IndexMixin
    end
  end
end
