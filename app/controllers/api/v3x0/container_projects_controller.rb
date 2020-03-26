module Api
  module V3x0
    class ContainerProjectsController < Api::V2x0::ContainerProjectsController
      include Mixins::IndexMixin
    end
  end
end
