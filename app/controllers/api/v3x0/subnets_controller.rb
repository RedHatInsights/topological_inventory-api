module Api
  module V3x0
    class SubnetsController < Api::V2x0::SubnetsController
      include Mixins::IndexMixin
    end
  end
end
