module Api
  module V0x1
    module Mixins
      module IndexMixin
        def index
          render json: ManageIQ::API::Common::PaginatedResponse.new(
            base_query: scoped(model.where(params_for_list)),
            request: request,
            limit: pagination_limit,
            offset: pagination_offset
          ).response
        rescue ActionController::UnpermittedParameters => error
          error_document = {
            "errors" => [
              {
                "status" => "400",
                "detail" => "#{error.message} in request parameters"
              }
            ]
          }
          render :json => error_document, :status => :bad_request
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
