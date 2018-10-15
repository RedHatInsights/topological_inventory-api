module Api
  module V0
    class ContainerTemplatesController < ApplicationController
      def index
        render json: ContainerTemplate.all
      end

      def show
        render json: ContainerTemplate.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
