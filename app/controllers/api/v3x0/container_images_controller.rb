module Api
  module V3x0
    class ContainerImagesController < Api::V1::ContainerImagesController
      include Mixins::IndexMixin
    end
  end
end
