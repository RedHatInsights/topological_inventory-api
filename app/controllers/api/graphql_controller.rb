require 'api/graphql'

module Api
  class GraphqlController < ApplicationController
    def query
      result = Api::GraphQL::Schema.execute(
        params[:query],
        :variables => params[:variables]
      )
      render :json => result
    end
  end
end
