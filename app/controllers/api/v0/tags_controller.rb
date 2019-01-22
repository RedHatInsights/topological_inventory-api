module Api
  module V0
    class TagsController < ApplicationController
      include Api::Mixins::IndexMixin
      include Api::Mixins::ShowMixin

      def list_params
        params.permit(:tenant_id)
      end

      def model
        Tag
      end
    end
  end
end
