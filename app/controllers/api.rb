module Api
  class RootController < ApplicationController
    def invalid_url_error
      error_document = ManageIQ::API::Common::ErrorDocument.new.add(404, "Invalid URL /#{params[:path]} specified.")
      render :json => error_document.to_h, :status => :not_found
    end
  end
end
