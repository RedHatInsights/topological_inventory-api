module Api
  module V0
    class ContainerNodesController < ApplicationController
      def index
        render json: ContainerNode.where(list_params)
      end

      def show
        render json: ContainerNode.find(params[:id])
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
