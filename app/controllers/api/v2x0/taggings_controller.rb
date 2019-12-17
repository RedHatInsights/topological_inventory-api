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

      def tag
        primary_instance = primary_collection_model.find(request_path_parts["primary_collection_id"])

        applied_tags = parsed_body.collect do |i|
          begin
            tag = Tag.find_or_create_by!(Tag.parse(i["tag"]))
            primary_instance.tags << tag
            i
          rescue ActiveRecord::RecordNotUnique
          end
        end.compact

        return head(:not_modified, :location => "#{instance_link(primary_instance)}/tags") if applied_tags.empty?

        render :json => parsed_body, :status => :created, :location => "#{instance_link(primary_instance)}/tags"
      end

      def untag
        primary_instance = primary_collection_model.find(request_path_parts["primary_collection_id"])

        parsed_body.each do |i|
          tag = Tag.find_by!(Tag.parse(i["tag"]))
          primary_instance.tags.destroy(tag)
        end

        head :no_content, :location => "#{instance_link(primary_instance)}/tags"
      end

      private

      def model
        primary_collection_model.tagging_relation_name.to_s.singularize.classify.safe_constantize
      end
    end
  end
end
