module Internal
  module V1
    class SourcesController < ::ApplicationController
      skip_before_action(:validate_request) # Doesn't validate against openapi.json

      include Api::V1::Mixins::UpdateMixin
    end
  end
end
