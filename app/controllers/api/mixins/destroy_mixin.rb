module Api
  module Mixins
    module DestroyMixin
      def destroy
        model.destroy(params.require(:id))
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
