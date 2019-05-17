module Api
  class GraphqlController < ApplicationController
    def query
      result = GraphQL::Schema.execute(
        params[:query],
        :variables => params[:variables]
      )
      render :json => result
    end
  end
end
