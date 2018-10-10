module Api
  module V0
    class ServiceOfferingsController < ApplicationController
      def index
        render json: ServiceOffering.all
      end

      def show
        render json: ServiceOffering.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
