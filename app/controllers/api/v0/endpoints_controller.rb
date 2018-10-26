module Api
  module V0
    class EndpointsController < ApplicationController
      include Api::Mixins::DestroyMixin
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin
      include Api::Mixins::UpdateMixin

      def create
        endpoint = Endpoint.create!(create_params)
        render :json => endpoint, :status => :created, :location => api_v0x0_endpoint_url(endpoint.id)
      end

      private

      def create_params
        body_params.permit(:role, :port, :source_id, :default, :scheme, :host, :path, :tenant_id)
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
