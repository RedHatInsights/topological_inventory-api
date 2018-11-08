module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def order
        service_plan = model.find(params[:service_plan_id])
        catalog_parameters = params[:service_parameters].permit!.merge(params[:provider_control_parameters].permit!)
        task_id = service_plan.order(params[:catalog_id], catalog_parameters)
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
