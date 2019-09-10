require "sources-api-client"

module Api
  module V1
    class ServicePlansController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
      include Api::V1::Mixins::SourcesApiMixin

      def order
        service_plan = model.find(request_path_parts["primary_collection_id"].to_i)
        source_type  = retrieve_source_type(service_plan)
        task         = Task.create!(:tenant => service_plan.tenant, :state => "pending", :status => "ok")

        messaging_client.publish_topic(
          :service => "platform.topological-inventory.operations-#{source_type.name}",
          :event   => "ServicePlan.order",
          :payload => payload_for_order(task, service_plan)
        )

        render :json => {:task_id => task.id}
      rescue ActiveRecord::RecordNotFound
        head :bad_request
      rescue StandardError => err
        error_document = ManageIQ::API::Common::ErrorDocument.new.add(err.message)
        render :json => error_document.to_h, :status => error_document.status
      end

      private

      def payload_for_order(task, service_plan)
        {
          :request_context => ManageIQ::API::Common::Request.current_forwardable,
          :params          => {
            :order_params    => body_params,
            :service_plan_id => service_plan.id.to_s,
            :task_id         => task.id.to_s,
          }
        }
      end
    end
  end
end
