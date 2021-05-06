module Api
  module V3x0
    module Mixins
      module IndexMixin
        def index
          if params[:test]
            Rails.logger.info("STDERR_TP_API test_message #{ENV['LOG_HANDLER']}")
            Rails.logger.warn("STDERR_TP_API test_message")
            Rails.logger.error("STDERR_TP_API test_message")
          end

          raise_unless_primary_instance_exists
          render :json => Insights::API::Common::PaginatedResponseV2.new(
            :base_query => scoped(filtered.where(params_for_list)),
            :request    => request,
            :limit      => pagination_limit,
            :offset     => pagination_offset,
            :sort_by    => query_sort_by
          ).response
        end
      end
    end
  end
end
