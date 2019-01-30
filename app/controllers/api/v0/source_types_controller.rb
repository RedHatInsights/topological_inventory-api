module Api
  module V0
    class SourceTypesController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def create
        source = model.create!(create_params)
        render :json => source, :status => :created, :location => api_v0x0_source_type_url(source.id)
      end

      private

      def create_params
        body_params.permit(:name, :product_name, :vendor, :schema)
      end

      def list_params
        params.permit(:name, :product_name, :vendor)
      end
    end
  end
end
