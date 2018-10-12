module Api
  module V0
    class ContainerProjectsController < ApplicationController
      def index
        render json: ContainerProject.all
      end

      def show
        render json: ContainerProject.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
