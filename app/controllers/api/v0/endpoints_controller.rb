module Api
  module V0
    class EndpointsController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def create
        endpoint = Endpoint.create!(params_for_create)
        render :json => endpoint, :status => :created, :location => instance_link(endpoint)
      end

      private

      def update_params
        params.permit(:role, :port, :source_id, :default, :scheme, :host, :path, :id)
      end
    end
  end
end
