module Api
  module V0
    class ServiceOfferingsController < ApplicationController
      include Api::Mixins::IndexMixin

      def show
        render json: ServiceOffering.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id)
      end

      def model
        ServiceOffering
      end
    end
  end
end
