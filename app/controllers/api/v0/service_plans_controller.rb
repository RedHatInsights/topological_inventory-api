module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def order
        service_plan = model.find(params[:id])
        task_id = service_plan.order(params[:catalog_id], params[:other_params?])
        render :json => {:task_id => task_id}
      end

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
