module Api
  module V3x0
    class ContainerGroupsController < Api::V2x0::ContainerGroupsController
      include Mixins::IndexMixin
    end
  end
end
