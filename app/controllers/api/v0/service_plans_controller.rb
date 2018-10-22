module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id)
      end

      def model
        ServicePlan
      end
    end
  end
end
