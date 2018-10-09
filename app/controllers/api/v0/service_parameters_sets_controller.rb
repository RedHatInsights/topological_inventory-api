module Api
  module V0
    class ServiceParametersSetsController < ApplicationController
      def index
        render json: ServiceParametersSet.all
      end
    end
  end
end
