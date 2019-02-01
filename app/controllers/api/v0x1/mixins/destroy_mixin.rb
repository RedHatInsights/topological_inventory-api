module Api
  module V0x1
    module Mixins
      module DestroyMixin
        def destroy
          super
        rescue ActionController::UnpermittedParameters => error
          error_document = {
            "errors" => [
              {
                "status" => "400",
                "detail" => "#{error.message} in request parameters"
              }
            ]
          }
          render :json => error_document, :status => :bad_request
        end
      end
    end
  end
end
