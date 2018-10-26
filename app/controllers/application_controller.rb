class ApplicationController < ActionController::API
  def body_params
    ActionController::Parameters.new(JSON.parse(request.body.read))
  end
end
