module Api
  module V0
    class TasksController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin
    end
  end
end
