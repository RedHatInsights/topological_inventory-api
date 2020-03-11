module Api
  module V3x0
    class ContainerProjectsController < Api::V1::ContainerProjectsController
      include Mixins::IndexMixin
    end
  end
end
