module Api
  module V0
    class ServiceParametersSetsController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      private

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id)
      end

      def model
        ServiceParametersSet
      end
    end
  end
end
