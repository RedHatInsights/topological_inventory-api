module Api
  module Mixins
    module DestroyMixin
      def destroy
        model.destroy(params[:id])
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
