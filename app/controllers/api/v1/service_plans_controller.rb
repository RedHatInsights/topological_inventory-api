require "sources-api-client"

module Api
  module V1
    class ServicePlansController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin

      def order
        service_plan = model.find(params_for_order[:service_plan_id].to_i)

        source_type = retrieve_source_type(service_plan)
        task = Task.create!(:tenant => service_plan.tenant, :state => "pending", :status => "ok")

        messaging_client.publish_message(
          :service => "platform.topological-inventory.operations-#{source_type.name}",
          :message => "ServicePlan.order",
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

      def sources_api_client
        @sources_api_client ||=
          begin
            identity = { 'x-rh-identity' => request.headers.fetch('x-rh-identity') }
            api_client = SourcesApiClient::ApiClient.new
            api_client.default_headers.merge!(identity)
            SourcesApiClient::DefaultApi.new(api_client)
          end
      end

      def retrieve_source_type(service_plan)
        source = sources_api_client.show_source(service_plan.source_id.to_s)
        if source.present?
          source_type = sources_api_client.show_source_type(source.source_type_id.to_s)
          if source_type.present?
            source_type
          else
            raise SourcesApiClient::ApiError.new(:message => "Error retrieving Source Type (ID #{source.source_type_id.to_s})")
          end
        else
          raise SourcesApiClient::ApiError.new(:message => "Error retrieving Source (ID #{service_plan.source_id.to_s})")
        end

      # Add Sources API message prefix
      rescue SourcesApiClient::ApiError => err
        raise SourcesApiClient::ApiError.new(:message => "Sources API: #{err.message} (code #{err.code})")
      end

      def params_for_order
        @params_for_order ||= params.permit(
          :service_plan_id,
          :service_parameters          => {},
          :provider_control_parameters => {}
        ).to_h
      end

      def payload_for_order(task, service_plan)
        {
          :request_context => ManageIQ::API::Common::Request.current_forwardable,
          :params          => {
            :order_params    => params_for_order,
            :service_plan_id => service_plan.id.to_s,
            :task_id         => task.id.to_s,
          }
        }
      end
    end
  end
end
