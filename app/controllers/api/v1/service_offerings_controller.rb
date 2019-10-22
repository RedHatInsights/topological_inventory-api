module Api
  module V1
    class ServiceOfferingsController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
      include Api::V1::Mixins::SourcesApiMixin

      def order
        send_message_and_generate_task_for(:order)
      end

      # POST
      def approval_inventories
        send_message_and_generate_task_for(:approval_inventories)
      end

      private

      def send_message_and_generate_task_for(operation_type)
        operation_params = send("params_for_#{operation_type}".to_sym)
        service_offering = model.find(operation_params[:service_offering_id].to_i)

        source_type = retrieve_source_type(service_offering)
        task = Task.create!(:tenant => service_offering.tenant, :state => "pending", :status => "ok")

        payload = send("payload_for_#{operation_type}".to_sym, task, service_offering)

        messaging_client.publish_topic(
          :service => "platform.topological-inventory.operations-#{source_type.name}",
          :event   => "ServiceOffering.#{operation_type}",
          :payload => payload
        )

        render :json => {:task_id => task.id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      rescue StandardError => err
        error_document = ManageIQ::API::Common::ErrorDocument.new.add(err.message)
        render :json => error_document.to_h, :status => error_document.status
      end

      def params_for_order
        @params_for_order ||= params.permit(
          :service_offering_id,
          :service_plan_id,
          :service_parameters          => {},
          :provider_control_parameters => {}
        ).to_h
      end

      def params_for_approval_inventories
        @params_for_approval_inventories ||= params.permit(
          :service_offering_id,
          :service_parameters => {}
        ).to_h
      end

      def payload_for_order(task, service_offering)
        payload = {
          :request_context => ManageIQ::API::Common::Request.current_forwardable,
          :params          => {
            :order_params        => params_for_order,
            :service_offering_id => service_offering.id.to_s,
            :task_id             => task.id.to_s,
          }
        }
        payload[:params][:service_plan_id] = params_for_order[:service_plan_id].to_s if params_for_order[:service_plan_id].present?
        payload
      end

      def payload_for_approval_inventories(task, service_offering)
        {
          :request_context => ManageIQ::API::Common::Request.current_forwardable,
          :params          => {
            :inventory_params => params_for_approval_inventories,
            :service_offering_id => service_offering.id.to_s,
            :task_id => task.id.to_s
          }
        }
      end
    end
  end
end
