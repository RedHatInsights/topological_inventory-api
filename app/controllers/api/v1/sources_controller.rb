module Api
  module V1
    class SourcesController < ApplicationController
      def create
        body = JSON.parse(request.body.read)
        source = Source.create!(:name => body["name"])
        render :json => source, :status => :created, :location => api_v1x0_source_url(source.id)
      end

      def destroy
        Source.destroy(params[:id])
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def index
        render json: Source.all
      end

      def show
        render json: Source.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def update
        Source.update(params[:id], :name => params[:name])
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
