module Api
  module V0
    class ProvidersController < ApplicationController
      def index
        render json: Source.all
      end
    end
  end
end
