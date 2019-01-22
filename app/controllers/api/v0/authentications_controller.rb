module Api
  module V0
    class AuthenticationsController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def create
        authentication = model.create!(create_params)
        render :json => authentication, :status => :created, :location => api_v0x0_authentication_url(authentication.id)
      end

      private

      def create_params
        body_params.permit(:tenant_id, :authtype, :name, :password, :resource_type, :resource_id, :username)
      end

      def update_params
        params.permit(:authtype, :name, :password, :username)
      end

      def list_params
        params.permit(:tenant_id, :authtype, :name, :resource_type, :resource_id, :status, :status_details, :username)
      end

      def model
        Authentication
      end
    end
  end
end
