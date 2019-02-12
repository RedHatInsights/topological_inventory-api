module Api
  module V0
    class SourcesController < ApplicationController
      include Api::V0::Mixins::DestroyMixin
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
      include Api::V0::Mixins::UpdateMixin

      def set_the_current_tenant
        # Auto-create tenant if creating a new source and tenant does not exist
        Tenant.find_or_create_by(:external_tenant => user_identity) if action_name == "create"

        super
      end

      def create
        source = Source.create!(params_for_create.merge!("uid" => SecureRandom.uuid))
        render :json => source, :status => :created, :location => instance_link(source)
      end
    end
  end
end
