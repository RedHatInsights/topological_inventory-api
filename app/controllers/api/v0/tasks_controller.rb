module Api
  module V0
    class TasksController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      private

      def list_params
        params.permit(:tenant_id)
      end

      def update_params
        params.permit(:status, :context)
      end

      def model
        Task
      end
    end
  end
end
