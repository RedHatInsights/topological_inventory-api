module Api
  module V0
    class ServiceOfferingIconsController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def icon_data
        service_offering_icon = model.find(params[:service_offering_icon_id].to_i)

        send_data(service_offering_icon.data, 
          :type         => MimeMagic.by_magic(service_offering_icon.data).type,
          :disposition  => 'inline')
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def model
        ServiceOfferingIcon
      end
    end
  end
end
