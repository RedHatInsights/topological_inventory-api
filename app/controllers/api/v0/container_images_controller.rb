module Api
  module V0
    class ContainerImagesController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def index
        render json: model.where(list_params).includes(:container_image_tags => :tag).references(:container_image_tags => :tag)
      end

      private

      def list_params
        params.permit(:source_id, :tenant_id)
      end

      def model
        ContainerImage
      end
    end
  end
end
