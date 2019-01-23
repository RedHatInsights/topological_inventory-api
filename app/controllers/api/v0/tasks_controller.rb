module Api
  module V0
    class TasksController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def list_params
        params.permit(:tenant_id, :limit, :offset)
      end
    end
  end
end
