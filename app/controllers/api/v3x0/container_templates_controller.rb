module Api
  module V3x0
    class ContainerTemplatesController < Api::V2x0::ContainerTemplatesController
      include Mixins::IndexMixin
    end
  end
end
