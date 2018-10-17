module Api
  module V0
    class ContainerProjectsController < ApplicationController
      def index
        render json: ContainerProject.where(list_params)
      end

      def show
        render json: ContainerProject.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id)
      end
    end
  end
end
