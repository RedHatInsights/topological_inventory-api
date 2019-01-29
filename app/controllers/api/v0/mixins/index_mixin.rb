module Api
  module V0
    module Mixins
      module IndexMixin
        def index
          render json: scoped(model.where(list_params))
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
