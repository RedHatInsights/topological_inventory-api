module Api
  module V0
    class SourcesController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def create
        source = Source.create!(create_params.merge!("uid" => SecureRandom.uuid))
        render :json => source, :status => :created, :location => api_v0x0_source_url(source.id)
      end

      private

      def create_params
        body_params.permit(:name, :source_type_id, :tenant_id)
      end

      def update_params
        params.permit(:name)
      end

      def list_params
        params.permit(:tenant_id, :source_type_id)
      end

      def model
        Source
      end
    end
  end
end
