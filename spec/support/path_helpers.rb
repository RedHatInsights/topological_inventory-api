module Spec
  module Support
    module PathHelpers
      def delete_path(path)
        parsed_params = Rails.application.routes.recognize_path(path, :method => "DELETE")
        delete(parsed_params[:action], :params => parsed_params.except(:action, :controller))
      end

      def get_path(path)
        parsed_params = Rails.application.routes.recognize_path(path)
        get(parsed_params[:action], :params => parsed_params.except(:action, :controller))
      end

      def patch_path(path, params)
        parsed_params = Rails.application.routes.recognize_path(path, :method => "PATCH")
        patch(parsed_params[:action], :params => params[:params].merge(parsed_params.except(:action, :controller)))
      end

      def post_path(path, options)
        parsed_params = Rails.application.routes.recognize_path(path, :method => "POST")
        post(parsed_params[:action], options)
      end
    end
  end
end
