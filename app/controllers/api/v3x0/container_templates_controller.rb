module Api
  module V3x0
    class ContainerTemplatesController < Api::V1::ContainerTemplatesController
      include Mixins::IndexMixin
    end
  end
end
