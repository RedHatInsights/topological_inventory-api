module Api
  module V3x0
    class SubnetsController < Api::V1::SubnetsController
      include Mixins::IndexMixin
    end
  end
end
