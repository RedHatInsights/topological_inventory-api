module Api
  module V2x0
    class TaggingsController < ApplicationController
      include Api::V1::Mixins::IndexMixin

      # Present these as tags
      private_class_method def self.api_doc_definition
        @api_doc_definition ||= api_doc.definitions["Tag"]
      end

      def self.presentation_name
        "Tag".freeze
      end

      def create
        primary_instance = primary_collection_model.find(request_path_parts["primary_collection_id"])
        tag = Tag.find_or_create_by!(Tag.parse(params_for_create["tag"]))

        return head(:not_modified, :location => "#{instance_link(primary_instance)}/tags") if primary_instance.tags.include?(tag)

        primary_instance.tags << tag
        render :json => tag, :status => :created, :location => "#{instance_link(primary_instance)}/tags"
      end

      def destroy
        primary_instance = primary_collection_model.find(request_path_parts["primary_collection_id"])
        tag = Tag.find_by!(Tag.parse(body_params["tag"]))
        primary_instance.tags.destroy(tag)

        head :no_content, :location => "#{instance_link(primary_instance)}/tags"
      end

      private

      def model
        primary_collection_model.tagging_relation_name.to_s.singularize.classify.safe_constantize
      end
    end
  end
end
