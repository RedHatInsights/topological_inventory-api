module Api
  module V3x0
    class ContainerResourceQuotasController < Api::V1::ContainerResourceQuotasController
      include Mixins::IndexMixin
    end
  end
end
