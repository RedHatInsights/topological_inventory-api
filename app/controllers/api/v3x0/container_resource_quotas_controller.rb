module Api
  module V3x0
    class ContainerResourceQuotasController < Api::V2x0::ContainerResourceQuotasController
      include Mixins::IndexMixin
    end
  end
end
