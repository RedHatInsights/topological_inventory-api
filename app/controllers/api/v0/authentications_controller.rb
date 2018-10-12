module Api
  module V0
    class AuthenticationsController < ApplicationController
      def create
        authentication = Authentication.create!(create_params)
        render :json => authentication, :status => :created, :location => api_v0x0_authentication_url(authentication.id)
      end

      def destroy
        Authentication.destroy(params[:id])
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def index
        render json: Authentication.all
      end

      def show
        render json: Authentication.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def update
        Authentication.update(params[:id], update_params)
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def create_params
        ActionController::Parameters.new(JSON.parse(request.body.read)).permit(:authtype, :name, :password, :resource_id, :resource_type, :status, :status_details, :userid)
      end

      def update_params
        params.permit(:authtype, :name, :password, :resource_id, :resource_type, :status, :status_details, :userid)
      end
    end
  end
end
