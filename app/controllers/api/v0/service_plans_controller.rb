module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def order
        service_plan = model.find(service_plan_id)
        task_id = service_plan.order(catalog_parameters)
        render :json => {:task_id => task_id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      end

      private

      def catalog_parameters
        order_params[:service_parameters].merge(order_params[:provider_control_parameters])
      end

      def service_plan_id
        params[:service_plan_id].to_i
      end

      def order_params
        params.permit(
          :service_parameters          => [:DB_NAME, :namespace],
          :provider_control_parameters => [:namespace, :OpenShift_param1]
        ).to_h
      end

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id)
      end

      def model
        ServicePlan
      end
    end
  end
end
