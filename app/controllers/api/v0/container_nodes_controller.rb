module Api
  module V0
    class ContainerNodesController < ApplicationController
      include Api::Mixins::IndexMixin

      def show
        render json: ContainerNode.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id)
      end

      def model
        ContainerNode
      end
    end
  end
end
