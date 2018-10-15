module Api
  module V0
    class ContainerGroupsController < ApplicationController
      def index
        render json: ContainerGroup.all
      end

      def show
        render json: ContainerGroup.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
