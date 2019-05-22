require 'api/graphql'

module Api
  class GraphqlController < ApplicationController
    def query
      variables = ensure_hash(params[:variables])
      result = Api::GraphQL::Schema.execute(
        params[:query],
        :variables => variables,
      )
      render :json => result
    end

    private

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end
end
