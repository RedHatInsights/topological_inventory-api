module Api
  module V0
    class EndpointsController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def create
        endpoint = Endpoint.create!(create_params)
        render :json => endpoint, :status => :created, :location => instance_link(endpoint)
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
    end
  end
end
