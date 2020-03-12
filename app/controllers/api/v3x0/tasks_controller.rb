module Api
  module V3x0
    class TasksController < Api::V2x0::TasksController
      include Mixins::IndexMixin
    end
  end
end
