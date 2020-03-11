module Api
  module V3x0
    class ContainerGroupsController < Api::V1::ContainerGroupsController
      include Mixins::IndexMixin
    end
  end
end
