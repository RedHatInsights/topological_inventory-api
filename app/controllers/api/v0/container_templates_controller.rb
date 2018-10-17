module Api
  module V0
    class ContainerTemplatesController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      private

      def list_params
        params.permit(:source_id, :tenant_id, :container_project_id)
      end

      def model
        ContainerTemplate
      end
    end
  end
end
