module Api
  module Mixins
    module ShowMixin
      def show
        render json: model.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
