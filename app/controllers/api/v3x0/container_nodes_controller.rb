module Api
  module V3x0
    class ContainerNodesController < Api::V2x0::ContainerNodesController
      include Mixins::IndexMixin
    end
  end
end
