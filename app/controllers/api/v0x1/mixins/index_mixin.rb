module Api
  module V0x1
    module Mixins
      module IndexMixin
        def index
          render json: ManageIQ::API::Common::PaginatedResponse.new(
            base_query: model.where(list_params),
            request: request,
            limit: params.permit(:limit)[:limit],
            offset: params.permit(:offset)[:offset]
          ).response
        end
      end
    end
  end
end
