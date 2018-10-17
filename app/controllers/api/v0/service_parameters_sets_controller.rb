module Api
  module V0
    class ServiceParametersSetsController < ApplicationController
      def index
        render json: ServiceParametersSet.where(list_params)
      end

      def show
        render json: ServiceParametersSet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id)
      end
    end
  end
end
