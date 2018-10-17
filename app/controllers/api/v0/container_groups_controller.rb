module Api
  module V0
    class ContainerGroupsController < ApplicationController
      def index
        render json: ContainerGroup.where(list_params)
      end

      def show
        render json: ContainerGroup.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id, :container_project_id, :container_node_id)
      end
    end
  end
end
