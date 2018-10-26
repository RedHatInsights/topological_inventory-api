module Api
  module Mixins
    module UpdateMixin
      def update
        model.update(params.require(:id), update_params)
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
