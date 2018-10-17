module Api
  module V0
    class ServiceInstancesController < ApplicationController
      def index
        render json: ServiceInstance.where(list_params)
      end

      def show
        render json: ServiceInstance.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id, :service_parameters_set_id)
      end
    end
  end
end
