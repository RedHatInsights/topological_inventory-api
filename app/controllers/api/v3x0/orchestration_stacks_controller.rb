module Api
  module V3x0
    class OrchestrationStacksController < Api::V2x0::OrchestrationStacksController
      include Mixins::IndexMixin
    end
  end
end
