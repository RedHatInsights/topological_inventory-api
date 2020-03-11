module Api
  module V3x0
    class OrchestrationStacksController < Api::V1::OrchestrationStacksController
      include Mixins::IndexMixin
    end
  end
end
