require 'topological_inventory/api/clowder_config'

module Api
  module V1
    class TasksController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin

      def update
        model.update(params.require(:id), params_for_update)

        if ENV['NO_KAFKA'].blank?
          TopologicalInventory::Api::Messaging.client.publish_topic(
            :service => TopologicalInventory::Api::ClowderConfig.kafka_topic("platform.topological-inventory.task-output-stream"),
            :event   => "Task.update",
            :payload => params_for_update.to_h.merge("id" => params.require(:id)),
            :headers => Insights::API::Common::Request.current_forwardable
          )
        end

        head :no_content
      end

      private

      def params_for_update
        permitted = api_doc_definition.all_attributes - api_doc_definition.read_only_attributes
        if body_params['context'].present?
          permitted.delete('context')
          permitted << {'context'=>{}}
        end
        permitted << 'source_id'
        body_params.permit(*permitted)
      end
    end
  end
end
