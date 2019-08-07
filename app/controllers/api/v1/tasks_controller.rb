module Api
  module V1
    class TasksController < ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin

      def update
        model.update(params.require(:id), params_for_update)

        messaging_client.publish_topic(
          :service => "platform.topological-inventory.task-output-stream",
          :event   => "Task.update",
          :payload => params_for_update.to_h.merge("task_id" => params.require(:id))
        )

        head :no_content
      end

      private

      def params_for_update
        permitted = api_doc_definition.all_attributes - api_doc_definition.read_only_attributes
        if body_params['context'].present?
          permitted.delete('context')
          permitted << {'context' => {}}
        end
        body_params.permit(*permitted)
      end
    end
  end
end
