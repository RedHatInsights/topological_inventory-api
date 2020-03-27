module Api
  module V3x0
    class TaggingsController < Api::V2x0::TaggingsController
      include Mixins::IndexMixin

      def extra_filter_attributes
        {"namespace" => {"type" => "string"}, "name" => {"type" => "string"}, "value" => {"type" => "string"}}
      end
    end
  end
end
