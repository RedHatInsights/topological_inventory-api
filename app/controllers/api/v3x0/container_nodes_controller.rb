module Api
  module V3x0
    class ContainerNodesController < Api::V1::ContainerNodesController
      include Mixins::IndexMixin
    end
  end
end
