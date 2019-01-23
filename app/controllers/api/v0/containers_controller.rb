module Api
  module V0
    class ContainersController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      private

      def list_params
        params.permit(:tenant_id, :container_group_id, :limit, :offset)
      end
    end
  end
end
