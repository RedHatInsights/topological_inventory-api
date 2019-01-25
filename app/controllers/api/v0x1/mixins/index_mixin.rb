module Api
  module V0x1
    module Mixins
      module IndexMixin
        def index
          render json: ManageIQ::API::Common::PaginatedResponse.new(
            base_query: scoped(model.where(list_params)),
            request: request,
            limit: params.permit(:limit)[:limit],
            offset: params.permit(:offset)[:offset]
          ).response
        end

        def scoped(relation)
          if model.respond_to?(:taggable?) && model.taggable?
            ref_schema = {model.tagging_relation_name => :tag}

            relation = relation.includes(ref_schema).references(ref_schema)
          end

          relation
        end
      end
    end
  end
end
