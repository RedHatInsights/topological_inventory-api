module Api
  module V1
    module Mixins
      module SourcesApiMixin
        def sources_api_client
          @sources_api_client ||=
            begin
              identity = { 'x-rh-identity' => request.headers.fetch('x-rh-identity') }
              api_client = SourcesApiClient::ApiClient.new
              api_client.default_headers.merge!(identity)
              SourcesApiClient::DefaultApi.new(api_client)
            end
        end

        def retrieve_source_type(service_plan)
          source = sources_api_client.show_source(service_plan.source_id.to_s)
          if source.present?
            source_type = sources_api_client.show_source_type(source.source_type_id.to_s)
            if source_type.present?
              source_type
            else
              raise SourcesApiClient::ApiError.new(:message => "Error retrieving Source Type (ID #{source.source_type_id})")
            end
          else
            raise SourcesApiClient::ApiError.new(:message => "Error retrieving Source (ID #{service_plan.source_id})")
          end

        # Add message prefix to error
        rescue SourcesApiClient::ApiError => err
          raise SourcesApiClient::ApiError.new(:message => "Sources API: #{err.message} (code #{err.code})")
        end
      end
    end
  end
end
