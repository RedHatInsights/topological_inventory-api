module Api
  module Cfme
    class ManifestController < ApplicationController
      def show
        version = params.permit(:id)[:id]
        raise ActionController::RoutingError.new('Not Found') unless version =~ /\A[\d\.]+\Z/

        file = TopologicalInventory::Api::CfmeManifest.find(version)
        raise ActionController::RoutingError.new('Not Found') unless file.exist?

        render :json => file.read
      end
    end
  end
end
