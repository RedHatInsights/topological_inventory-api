module Api
  module V0x1
    module Mixins
      module CreateMixin
        def create
          super
        rescue ActionController::UnpermittedParameters => error
          error_document = {
            "errors" => [
              {
                "status" => "400",
                "detail" => "#{error.message} in POST body"
              }
            ]
          }
          render :json => error_document, :status => :bad_request
        end
      end
    end
  end
end
