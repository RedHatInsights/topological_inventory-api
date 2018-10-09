module Api
  module V0
    class ServiceOfferingsController < ApplicationController
      def index
        render json: ServiceOffering.all
      end
    end
  end
end
