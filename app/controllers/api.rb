module Api
  class RootController < ApplicationController
    skip_before_action :validate_primary_collection_id

    def invalid_url_error
      error_document = Insights::API::Common::ErrorDocument.new.add("404", "Invalid URL /#{params[:path]} specified.")
      render :json => error_document.to_h, :status => :not_found
    end
  end
end
