module Api
  module V0
    class ServiceParametersSetsController < ApplicationController
      def index
        render json: ServiceParametersSet.all
      end

      def show
        render json: ServiceParametersSet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
