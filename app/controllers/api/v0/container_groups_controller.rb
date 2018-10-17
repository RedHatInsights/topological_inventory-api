module Api
  module V0
    class ContainerGroupsController < ApplicationController
      include Api::Mixins::IndexMixin

      def show
        render json: ContainerGroup.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id, :container_project_id, :container_node_id)
      end

      def model
        ContainerGroup
      end
    end
  end
end
