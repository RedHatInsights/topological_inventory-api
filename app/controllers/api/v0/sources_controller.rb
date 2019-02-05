module Api
  module V0
    class SourcesController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def create
        source = Source.create!(params_for_create.merge!("uid" => SecureRandom.uuid))
        render :json => source, :status => :created, :location => instance_link(source)
      end

      private

      def update_params
        params.permit(:name, :id)
      end
    end
  end
end
