module Api
  module V0
    class ServiceInstancesController < ApplicationController
      def index
        render json: ServiceInstance.all
      end

      def show
        render json: ServiceInstance.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
