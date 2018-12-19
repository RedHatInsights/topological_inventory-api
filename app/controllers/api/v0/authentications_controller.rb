module Api
  module V0
    class AuthenticationsController < ApplicationController
      include Api::Mixins::DestroyMixin
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin
      include Api::Mixins::UpdateMixin

      def create
        authentication = model.create!(create_params)
        render :json => authentication, :status => :created, :location => api_v0x0_authentication_url(authentication.id)
      end

      private

      def create_params
        body_params.permit(:tenant_id, :authtype, :name, :password, :resource_type, :resource_id, :userid)
      end

      def update_params
        params.permit(:authtype, :name, :password, :userid)
      end

      def list_params
        params.permit(:tenant_id, :authtype, :name, :resource_type, :resource_id, :status, :status_details, :userid)
      end

      def model
        Authentication
      end
    end
  end
end
