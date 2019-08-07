module Api
  module V1
    class ServiceOfferingIconsController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin

      def icon_data
        raise_unless_primary_instance_exists
        service_offering_icon = model.find(params[:service_offering_icon_id].to_i)

        send_data(service_offering_icon.data,
                  :type        => MimeMagic.by_magic(service_offering_icon.data).type,
                  :disposition => 'inline')
      end

      private

      def model
        ServiceOfferingIcon
      end
    end
  end
end
