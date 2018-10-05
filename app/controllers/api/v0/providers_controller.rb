module Api
  module V0
    class ProvidersController < ApplicationController
      def index
        render json: Legacy::Provider.all
      end
    end
  end
end
