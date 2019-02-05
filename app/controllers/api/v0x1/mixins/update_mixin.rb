module Api
  module V0x1
    module Mixins
      module UpdateMixin
        def update
          super
        rescue ActionController::UnpermittedParameters => error
          error_document = {
            "errors" => [
              {
                "status" => "400",
                "detail" => "#{error.message} in PATCH body"
              }
            ]
          }
          render :json => error_document, :status => :bad_request
        end
      end
    end
  end
end
