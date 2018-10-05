module Api
  module V0
    class ServiceOfferingsController < ApplicationController
      def index
        render json: Legacy::ServiceOffering.all
      end
    end
  end
end
