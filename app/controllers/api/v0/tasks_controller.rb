module Api
  module V0
    class TasksController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def list_params
        params.permit(:tenant_id)
      end

      def model
        Task
      end
    end
  end
end
