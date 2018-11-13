module Api
  module V0
    class SourceTypes < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def create
        source = model.create!(create_params)
        render :json => source, :status => :created, :location => api_v0x0_source_type_url(source.id)
      end

      private

      def create_params
        body_params.permit(:name, :product_name, :vendor)
      end

      def model
        SourceType
      end
    end
  end
end
