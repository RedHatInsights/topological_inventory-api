module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def order
        service_plan = model.find(service_plan_id)
        task_id = service_plan.order(order_params)
        render :json => {:task_id => task_id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      end

      private

      def service_plan_id
        params[:service_plan_id].to_i
      end

      def order_params
        params.permit(
          :service_parameters          => {},
          :provider_control_parameters => {}
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
