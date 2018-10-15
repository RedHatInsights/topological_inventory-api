module Api
  module V0
    class ContainerNodesController < ApplicationController
      def index
        render json: ContainerNode.all
      end

      def show
        render json: ContainerNode.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
