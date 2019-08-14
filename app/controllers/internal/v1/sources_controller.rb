module Internal
  module V1
    class SourcesController < ::ApplicationController
      include Api::V1::Mixins::UpdateMixin
    end
  end
end
