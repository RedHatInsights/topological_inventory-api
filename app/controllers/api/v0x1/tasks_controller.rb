module Api
  module V0x1
    class TasksController < Api::V0x0::TasksController
      include Api::V0x1::Mixins::IndexMixin

      def update
        model.update(params.require(:id), params_for_update)

        messaging_client.publish_message(
          :service => "platform.topological-inventory.task-output-stream",
          :message => "Task.update",
          :payload => params_for_update.to_h.merge("task_id" => params.require(:id))
        )

        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
