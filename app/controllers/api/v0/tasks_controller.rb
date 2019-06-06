module Api
  module V0
    class TasksController < ApplicationController
      include Api::V0::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin

      def update
        model.update(params.require(:id), params_for_update)

        messaging_client.publish_topic(
          :service => "platform.topological-inventory.task-output-stream",
          :event   => "Task.update",
          :payload => params_for_update.to_h.merge("task_id" => params.require(:id))
        )

        head :no_content
      end
    end
  end
end
