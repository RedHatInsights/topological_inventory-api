module Api
  module V0
    class ServiceInstancesController < ApplicationController
      include Api::Mixins::IndexMixin

      def show
        render json: ServiceInstance.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id, :service_parameters_set_id)
      end

      def model
        ServiceInstance
      end
    end
  end
end
