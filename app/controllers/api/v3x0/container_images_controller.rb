module Api
  module V3x0
    class ContainerImagesController < Api::V2x0::ContainerImagesController
      include Mixins::IndexMixin
    end
  end
end
