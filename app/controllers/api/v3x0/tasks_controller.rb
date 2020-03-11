module Api
  module V3x0
    class TasksController < Api::V1::TasksController
      include Mixins::IndexMixin
    end
  end
end
