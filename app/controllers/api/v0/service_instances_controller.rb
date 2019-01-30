module Api
  module V0
    class ServiceInstancesController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id, :service_plan_id)
      end
    end
  end
end
