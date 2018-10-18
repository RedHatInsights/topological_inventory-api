module Api
  module Mixins
    module IndexMixin
      def index
        render json: model.where(list_params)
      end
    end
  end
end
