module Api
  module V0
    class EndpointsController < ApplicationController
      include Api::Mixins::DestroyMixin
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def create
        endpoint = Endpoint.create!(create_params)
        render :json => endpoint, :status => :created, :location => api_v0x0_endpoint_url(endpoint.id)
      end

      def update
        Endpoint.update(params.require(:id), update_params)
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def create_params
        ActionController::Parameters.new(JSON.parse(request.body.read)).permit(:role, :port, :source_id, :default, :scheme, :host, :path, :tenant_id)
      end

      def update_params
        params.permit(:role, :port, :source_id, :default, :scheme, :host, :path)
      end

      def list_params
        params.permit(:source_id, :tenant_id)
      end

      def model
        Endpoint
      end
    end
  end
end
