module Api
  module V1
    class ServiceOfferingsController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
      include Api::V1::Mixins::SourcesApiMixin

      def order
        service_offering = model.find(params_for_order[:service_offering_id].to_i)

        source_type = retrieve_source_type(service_offering)
        task = Task.create!(:tenant => service_offering.tenant, :state => "pending", :status => "ok")

        messaging_client.publish_topic(
          :service => "platform.topological-inventory.operations-#{source_type.name}",
          :event   => "ServiceOffering.order",
          :payload => payload_for_order(task, service_offering)
        )

        render :json => {:task_id => task.id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      rescue StandardError => err
        error_document = ManageIQ::API::Common::ErrorDocument.new.add(err.message)
        render :json => error_document.to_h, :status => error_document.status
      end

      private

      def params_for_order
        @params_for_order ||= params.permit(
          :service_offering_id,
          :service_parameters          => {},
          :provider_control_parameters => {}
        ).to_h
      end

      def payload_for_order(task, service_offering)
        {
          :request_context => ManageIQ::API::Common::Request.current_forwardable,
          :params          => {
            :order_params        => params_for_order,
            :service_offering_id => service_offering.id.to_s,
            :task_id             => task.id.to_s,
          }
        }
      end
    end
  end
end
