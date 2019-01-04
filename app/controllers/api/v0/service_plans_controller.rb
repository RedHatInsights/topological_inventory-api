require "manageiq-messaging"

module Api
  module V0
    class ServicePlansController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def order
        service_plan = model.find(order_params[:service_plan_id].to_i)
        task = Task.create!(:tenant => service_plan.tenant, :status => "started")

        messaging_client.publish_message(
          :service => "topological_inventory-orderer",
          :message => "order_service",
          :payload => {:task_id => task.id, :service_plan_id => service_plan.id, :order_params => order_params}
        )

        render :json => {:task_id => task.id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      end

      private

      def service_plan_id
        params[:service_plan_id].to_i
      end

      def order_params
        params.permit(
          :service_plan_id,
          :service_parameters          => {},
          :provider_control_parameters => {}
        ).to_h
      end

      def list_params
        params.permit(:source_id, :tenant_id, :service_offering_id)
      end

      def messaging_client
        ManageIQ::Messaging::Client.open(messaging_opts)
      end

      def messaging_opts
        {
          :protocol => :Kafka,
          :host     => ENV["QUEUE_HOST"] || "localhost",
          :port     => ENV["QUEUE_PORT"] || "9092",
          :encoding => "json"
        }
      end

      def model
        ServicePlan
      end
    end
  end
end
