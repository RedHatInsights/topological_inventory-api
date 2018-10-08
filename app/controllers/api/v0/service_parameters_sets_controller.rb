module Api
  module V0
    class ServiceParametersSetsController < ApplicationController
      def index
        render json: Legacy::ServiceParametersSet.all
      end
    end
  end
end
